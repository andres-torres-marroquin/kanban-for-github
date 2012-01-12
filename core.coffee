$ ->
    $('#tabs').tabs()
    .tabs 'option', 'tabTemplate',
        '''
        <li>
            <a href='#{href}'>#{label}</a>
            <span class='ui-icon ui-icon-close'>Remove Tab</span>
        </li>'''

    render_user = (user) ->
        """
        <div id="title">
            Kanban for GitHub
        </div>
        <div id="user-name">
            #{user.login} |
            <a href="#" id="logout">logout</a>
        </div>
        <img id="user-avatar" src="#{user.avatar_url}" width="35" height="35" alt="#{user.login}" title="#{user.login}"/>
        """

    set_repo = (repo_url, client) ->
        container = "##{repo_url.split('/').slice(-1)}"
        $('#tabs').tabs 'add', container, container
        $("[href=#{container}]").click()
        b = new Board(repo_url, container, client)
        b.draw()
        if $.cookie 'saved'
            save_repo(repo_url)

    save_repo = (repo_url) ->
        repos = $.cookie('repos') or ''
        if repos.indexOf(repo_url) is -1
            if repos
                repos = "#{repos},#{repo_url}"
                $.cookie 'repos', repos
            else
                $.cookie 'repos', repo_url

    draw_repos = (client) ->
        render_repo = (repo) ->
            """
            <div class="repo-selector" data-repo-url="#{repo.url}">
                <a href="#{repo.html_url}" target="_blank">#{repo.html_url}</a>
                <button class="select-repo">Use this</button>
            </div>
            """

        repos = client.get_repos()

        repos.sort (a, b) ->
            if a.html_url > b.html_url
                1
            else if a.html_url < b.html_url
                -1
            else
                0

        repos = (render_repo repo for repo in repos).join('')
        $('#repos').append $ repos
        $('.repos').removeClass('hidden').click()

        $('.select-repo').die().live 'click', ->
            repo_url = $(this).parent().attr 'data-repo-url'
            set_repo(repo_url, client)

    start = (username, password) ->
        auth =
            username: username
            password: password

        try
            client = new GitHubApi auth
            draw_repos client
            $(render_user client.get_authenticated_user()).appendTo('#tab-header')
            $('#tabs').tabs 'remove', 0
            if $.cookie 'repos'
                (set_repo repo, client) for repo in $.cookie('repos').split(',')
        catch err
            alert 'Wrong credentials'
            throw err

    $('#loginform').submit ->
        $this = $ this
        username = $this.find('[name=username]').val()
        password = $this.find('[name=password]').val()
        save = $this.find('[name=save]').attr('checked')

        cookie_options =
            expires: 7 # Expires in seven days after login

        if save
            $.cookie 'username', username, cookie_options
            $.cookie 'password', password, cookie_options
            $.cookie 'saved', true, cookie_options

        start(username, password)

        false

    $("#tabs span.ui-icon-close").live "click", ->
        $tabs = $ '#tabs'
        index = $("li", $tabs).index($(this).parent())
        $tabs.tabs "remove", index
        r = $(this).parent().find('a').html()[1..]
        repos = $.cookie 'repos'
        repos = repos.split(',')
        repos = (repo for repo in repos when repo.indexOf(r) is -1).join(',')
        repos = $.cookie 'repos', repos

    $('#logout').live 'click', ->
        $.cookie 'saved', null
        $.cookie 'username', null
        $.cookie 'password', null
        $.cookie 'repos', null
        location.reload()
        false

    if $.cookie 'saved'
        username = $.cookie 'username'
        password = $.cookie 'password'
        start(username, password)

    $('body.hidden').removeClass 'hidden'
