client = # Fake client
    get_labels: ->
        [
            {name: 'Phase #3 - Reviewing'}
            {name: 'backlog'}
            {name: 'Phase #2 - Working'}
            {name: 'andres1'}
            {name: 'andres2'}
            {name: 'Phase #1 - Ready'}
            {name: 'andres3'}
        ]
    set_repo_url: ->
    get_issues: (parameters) ->
        if parameters.labels is 'Phase #1 - Ready'
            [
                {
                    number: 1
                    title: 'First'
                }
            ]
        else if parameters.labels is 'Phase #2 - Working'
            [
                {
                    number: 2
                    title: 'Second'
                }
            ]
        else if parameters.labels is 'Phase #3 - Reviewing'
            [
                {
                    number: 3
                    title: 'Third'
                }
            ]


b = new Board('asd', 'asd', client)



test("testing get_phases", ->
    phases = b.get_phases()

    equal(phases[0].name, 'Phase #1 - Ready')
    equal(phases[0].phase_name, 'Ready')
    equal(phases[0].number, '1')
    equal(phases[0].percentage, 33)

    equal(phases[1].name, 'Phase #2 - Working')
    equal(phases[1].phase_name, 'Working')
    equal(phases[1].number, '2')
    equal(phases[1].percentage, 33)

    equal(phases[2].name, 'Phase #3 - Reviewing')
    equal(phases[2].phase_name, 'Reviewing')
    equal(phases[2].number, '3')
    equal(phases[2].percentage, 33)
)

test("testing get_phases_display", ->
    phases = b.get_phases_display()
    equal(phases[0], 'Phase #1 - Ready')
    equal(phases[1], 'Phase #2 - Working')
    equal(phases[2], 'Phase #3 - Reviewing')
)

test("testing render_phase", ->
    phase =
        number: 1
        percentage: 33
        name: 'Phase #1 - Working'
        phase_name: 'Working'

    equal(render_phase(phase), """
        <div data-phase="phase1" class="phase ui-widget-content" style="width: 33%" data-name="Phase #1 - Working">
            <div class="phase-name ui-state-default">
                Working
            </div>
            <div class="issues"></div>
        </div>
    """)
)

test("testing render_issue with all the data", ->
    issue =
        assignee:
            avatar_url: 'avatar_test_url'
            login: 'test_login'
        comments: 15
        number: 123
        html_url: 'issue_test_url'
        title: 'issue_title'
        labels: [
            {name: 'blocked', color: '123456'},
            {name: 'test-label', color: '234567'},
            {name: 'new feature', color: '345678'},
        ]
    equal(render_issue(issue), """
        <div class="issue ui-widget-content" data-number="123">
            <div class="issue-header ui-state-default">
                <a href="issue_test_url" class="open-issue" target="_blank">
                    <span class="ui-icon ui-icon-search"></span>
                    <span class="issue-number">123</span>
                </a>
                <div class="issue-assignee">
                    <img src="avatar_test_url" width="20" height="20" alt="test_login" title="test_login"/>
                </div>
            </div>
            <div class="issue-name ui-widget-content">issue_title</div>
            <div class="labels"><div style="background: #123456" class="label">
            <span class="ui-icon ui-icon-tag"></span>blocked
        </div>
        <div style="background: #234567" class="label">
            <span class="ui-icon ui-icon-tag"></span>test-label
        </div>
        <div style="background: #345678" class="label">
            <span class="ui-icon ui-icon-tag"></span>new feature
        </div>
        </div>
            <div class="comments"><span class="ui-icon ui-icon-comment"></span> 15 comments</div>
        </div>
    """)
)

test("testing render_issue with any the data", ->
    issue =
        assignee: null
        comments: 0
        number: 123
        html_url: 'issue_test_url'
        title: 'issue_title'
        labels: []
    equal(render_issue(issue), """
        <div class="issue ui-widget-content" data-number="123">
            <div class="issue-header ui-state-default">
                <a href="issue_test_url" class="open-issue" target="_blank">
                    <span class="ui-icon ui-icon-search"></span>
                    <span class="issue-number">123</span>
                </a>
                <div class="issue-assignee">
                    <span class="issue-assignee-name">Not assigned</span>
                </div>
            </div>
            <div class="issue-name ui-widget-content">issue_title</div>
            <div class="labels"></div>
            <div class="comments"></div>
        </div>
    """)
)

