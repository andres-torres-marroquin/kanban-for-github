phase_regex = /Phase #\d+ - .+/

render_issue = (issue) ->
    if issue.assignee
        assignee = """
        <img src="#{issue.assignee.avatar_url}" width="20" height="20" alt="#{issue.assignee.login}" title="#{issue.assignee.login}"/>
        """
    else
        assignee = """
        <span class="issue-assignee-name">Not assigned</span>
        """

    if issue.comments
        comments = """
            <span class="ui-icon ui-icon-comment"></span> #{issue.comments} comments
        """
    else
        comments = ""

    labels = issue.labels
    labels = (label for label in labels when not phase_regex.test(label.name))
    labels = ("""
    <div style="background: ##{label.color}" class="label">
        <span class="ui-icon ui-icon-tag"></span>#{label.name}
    </div>

    """ for label in labels).join('')

    """
    <div class="issue ui-widget-content" data-number="#{issue.number}">
        <div class="issue-header ui-state-default">
            <a href="#{issue.html_url}" class="open-issue" target="_blank">
                <span class="ui-icon ui-icon-search"></span>
                <span class="issue-number">#{issue.number}</span>
            </a>
            <div class="issue-assignee">
                #{assignee}
            </div>
        </div>
        <div class="issue-name ui-widget-content">#{issue.title}</div>
        <div class="labels">#{labels}</div>
        <div class="comments">#{comments}</div>
    </div>
    """

render_phase = (phase) ->
    """
    <div data-phase="phase#{phase.number}" class="phase ui-widget-content" style="width: #{phase.percentage}%" data-name="#{phase.name}">
        <div class="phase-name ui-state-default">
            #{phase.phase_name}
        </div>
        <div class="issues"></div>
    </div>
    """

class Board
  constructor: (@repo_url, container, @client) ->
    @$container = $ container

  set_repo_url: (@repo_url) ->

  _edit_phase: (phase, percentage) ->
        phase.number = /\d+/.exec(phase.name)[0]
        phase.percentage = percentage
        phase.phase_name = phase.name.slice(11)
        phase

  get_phases: ->
    labels = @client.get_labels()
    phases = (label for label in labels when phase_regex.test(label.name))
    percentage = 99 / phases.length;
    phases = (@_edit_phase phase, percentage for phase in phases)
    phases.sort (a, b) ->
        if (a.name > b.name)
            1
        else if (a.name < b.name)
            -1
        else
            0
    phases

  get_phases_display: ->
    (phase.name for phase in @get_phases())

  draw: ->
    @client.set_repo_url @repo_url
    @draw_phase phase for phase in @get_phases()
    @setup_sortable()

  draw_phase: (phase) ->
    $phase = $ render_phase phase
    @$container.append $phase
    issues = @client.get_issues({labels: phase.name})
    @draw_issue issue, $phase for issue in issues

  draw_issue: (issue, $phase) ->
    $issue = $ render_issue issue
    $phase.find('.issues').append $issue

  setup_sortable: ->
    $issues = @$container.find '.issues'
    client = @client
    $issues.sortable
        connectWith: $issues
        distance: 15
        revert: true
        opacity: 0.9
        handle: '.issue-header'
        placeholder: "ui-state-highlight issue-placeholder"
        start: (event, ui) ->
            height = $(ui.item).height()
            $('.issue-placeholder').height(height - 20 + 4)
        stop: (event, ui) ->
            $element = $ ui.item
            number = $element.attr 'data-number'
            phase = $element.parents('.phase').attr 'data-name'
            labels = client.get_labels_for_issue number
            labels = (label.name for label in labels when not phase_regex.test(label.name))
            labels.push phase
            client.replace_labels_for_issue number, labels
    .disableSelection()
    $('.phases').removeClass('hidden').click()
    $('#tabs').scrollTop 0

@Board = Board

