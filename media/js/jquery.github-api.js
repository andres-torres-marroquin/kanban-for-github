var GITHUB_API_URL = 'https://api.github.com/';
//var GITHUB_API_URL_REPOS = GITHUB_API_URL + 'repos/';

function GitHubApi(auth) {
    this.is_auth_enabled = auth.username && auth.password;
    this.auth = "Basic " + Base64.encode(auth.username + ":" + auth.password);
}

GitHubApi.prototype.set_repo_url = function (repo_url) {
    this.repo_url = repo_url + '/';
}

GitHubApi.prototype.get_my_repos = function () {
    var response = null;
    $.ajax({
        url: GITHUB_API_URL + 'user/repos',
        async: false,
        headers: this._get_headers(),
        dataType: 'json',
        success: function(data) {
            response = data;
        }
    });
    return response;
}

GitHubApi.prototype.get_org_repos = function (org_name, parameters) {
    var response = null;
    var parameters = parameters || {};
    this._clean_params(parameters);
    $.ajax({
        url: GITHUB_API_URL + 'orgs/' + org_name + '/repos',
        async: false,
        data: parameters,
        headers: this._get_headers(),
        dataType: 'json',
        success: function(data) {
            response = data;
        }
    });
    return response;
}

GitHubApi.prototype.get_repos = function () {
    var repos = client.get_my_repos();
    var orgs = client.get_organizations()

    $.each(orgs, function(i, v) {
        var org_repos = client.get_org_repos(v.login, {
            type: 'member'
        });
        repos = repos.concat(org_repos);
    })
    return repos;
}


GitHubApi.prototype.get_organizations = function () {
    var response = null;
    $.ajax({
        url: GITHUB_API_URL + 'user/orgs',
        async: false,
        headers: this._get_headers(),
        dataType: 'json',
        success: function(data) {
            response = data;
        }
    });
    return response;
}

GitHubApi.prototype._clean_params = function (parameters) {
    $.each(parameters, function(i, param) {
        if (param == null)
            delete parameters[i];
    });
}

GitHubApi.prototype._get_headers = function (mime_type) {
    var headers = {};
    if(this.is_auth_enabled)
        headers['Authorization'] = this.auth;
    if(mime_type)
        headers['Accept'] = mime_type
    return headers;
}

GitHubApi.prototype.get_issues = function(parameters, mime_type) {
    var response = null;
    var parameters = parameters || {};
    var mime_type = mime_type || false;
    this._clean_params(parameters);
    $.ajax({
        url: this.repo_url + 'issues',
        async: false,
        data: parameters,
        headers: this._get_headers(mime_type),
        dataType: 'json',
        success: function(data) {
            response = data;
        }
    });
    return response;
}

GitHubApi.prototype.get_issue = function(issue_id, mime_type) {
    var response = null;
    var mime_type = mime_type || false;
    $.ajax({
        url: this.repo_url + 'issues/' + issue_id,
        async: false,
        dataType: 'json',
        headers: this._get_headers(mime_type),
        success: function(data) {
            response = data;
        }
    });
    return response;
}

GitHubApi.prototype.get_labels = function(parameters) {
    var response = null;
    var parameters = parameters || {};
    $.ajax({
        url: this.repo_url + 'labels',
        async: false,
        data: parameters,
        dataType: 'json',
        headers: this._get_headers(),
        success: function(data) {
            response = data;
        }
    });
    return response;
}

GitHubApi.prototype.get_label = function(label_name) {
    var response = null;
    $.ajax({
        url: this.repo_url + 'labels/' + label_name,
        async: false,
        dataType: 'json',
        headers: this._get_headers(),
        success: function(data) {
            response = data;
        }
    });
    return response;
}

GitHubApi.prototype.create_label = function(parameters) {
    var parameters = parameters || {};
    $.ajax({
        url: this.repo_url + 'labels',
        type: 'POST',
        dataType: 'json',
        data: JSON.stringify(parameters),
        headers: this._get_headers()
    });
}

GitHubApi.prototype.update_label = function(label_name, parameters) {
    var parameters = parameters || {};
    $.ajax({
        url: this.repo_url + 'labels/' + label_name,
        type: 'PATCH',
        dataType: 'json',
        data: JSON.stringify(parameters),
        headers: this._get_headers()
    });
}

GitHubApi.prototype.add_labels_to_issue = function(issue_id, labels) {
    $.ajax({
        url: this.repo_url + 'issues/' + issue_id + '/labels',
        type: 'POST',
        dataType: 'json',
        data: JSON.stringify(labels),
        headers: this._get_headers()
    });
}

GitHubApi.prototype.get_labels_for_issue = function(issue_id) {
    var response = null;
    $.ajax({
        url: this.repo_url + 'issues/' + issue_id + '/labels',
        async: false,
        dataType: 'json',
        headers: this._get_headers(),
        success: function(data) {
            response = data;
        }
    });
    return response;
}

GitHubApi.prototype.replace_labels_for_issue = function(issue_id, labels) {
    $.ajax({
        url: this.repo_url + 'issues/' + issue_id + '/labels',
        type: 'PUT',
        dataType: 'json',
        data: JSON.stringify(labels),
        headers: this._get_headers()
    });
}

GitHubApi.prototype.get_authenticated_user = function() {
    var response = null;
    $.ajax({
        url: GITHUB_API_URL + 'user',
        async: false,
        dataType: 'json',
        headers: this._get_headers(),
        success: function(data) {
            response = data;
        }
    });
    return response;
}