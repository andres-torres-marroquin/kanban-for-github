var GITHUB_API_URL = 'https://api.github.com/repos/';

function GitHubApi(user, repo, auth) {
    this.user = user;
    this.repo = repo;
    this.is_auth_enabled = auth.username && auth.password;
    this.auth = "Basic " + Base64.encode(auth.username + ":" + auth.password);
    this.base_url = GITHUB_API_URL + this.user + '/' + this.repo + '/';
}

GitHubApi.prototype._clean_params = function (parameters) {
    $.each(parameters, function(i, param) {
        if (param == null)
            delete parameters[i];
    });
}

GitHubApi.prototype.get_issues = function(parameters, mime_type) {
    var response = null;
    var parameters = parameters || {};
    var mime_type = mime_type || false;
    this._clean_params(parameters);
    var me = this;
    $.ajax({
        url: this.base_url + 'issues',
        async: false,
        data: parameters,
        dataType: 'json',
        beforeSend: function(xhr) {
            if(me.is_auth_enabled)
                xhr.setRequestHeader("Authorization", me.auth)
            if(mime_type)
                xhr.setRequestHeader("Accept", mime_type);
        },
        success: function(data) {
            $('#issues').html('');
            response = data;
        }
    });
    return response;
}

GitHubApi.prototype.get_issue = function(issue_id, mime_type) {
    var response = null;
    var mime_type = mime_type || false;
    var me = this;
    $.ajax({
        url: this.base_url + 'issues/' + issue_id,
        async: false,
        dataType: 'json',
        beforeSend: function(xhr) {
            if(me.is_auth_enabled)
                xhr.setRequestHeader("Authorization", me.auth)
            if(mime_type)
                xhr.setRequestHeader("Accept", mime_type);
        },
        success: function(data) {
            response = data;
        }
    });
    return response;
}

GitHubApi.prototype.get_labels = function(parameters) {
    var response = null;
    var parameters = parameters || {};
    var me = this;
    $.ajax({
        url: this.base_url + 'labels',
        async: false,
        data: parameters,
        dataType: 'json',
        beforeSend: function(xhr) {
            if(me.is_auth_enabled)
                xhr.setRequestHeader("Authorization", me.auth)
        },
        success: function(data) {
            response = data;
        }
    });
    return response;
}

GitHubApi.prototype.add_labels_to_issue = function(issue_id, labels) {
    var me = this;
    $.ajax({
        url: this.base_url + 'issues/' + issue_id + '/labels',
        type: 'POST',
        dataType: 'json',
        data: JSON.stringify(labels),
        beforeSend: function(xhr) {
            if(me.is_auth_enabled)
                xhr.setRequestHeader("Authorization", me.auth)
        }
    });
}

GitHubApi.prototype.get_labels_for_issue = function(issue_id) {
    var me = this;
    var response = null;
    $.ajax({
        url: this.base_url + 'issues/' + issue_id + '/labels',
        async: false,
        dataType: 'json',
        beforeSend: function(xhr) {
            if(me.is_auth_enabled)
                xhr.setRequestHeader("Authorization", me.auth);
        },
        success: function(data) {
            response = data;
        }
    });
    return response;
}

GitHubApi.prototype.replace_labels_for_issue = function(issue_id, labels) {
    var me = this;
    $.ajax({
        url: this.base_url + 'issues/' + issue_id + '/labels',
        type: 'PUT',
        dataType: 'json',
        data: JSON.stringify(labels),
        beforeSend: function(xhr) {
            if(me.is_auth_enabled)
                xhr.setRequestHeader("Authorization", me.auth);
        }
    });
}
