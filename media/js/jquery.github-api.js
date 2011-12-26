var GITHUB_API_URL = 'https://api.github.com/';
var GITHUB_API_URL_REPOS = GITHUB_API_URL + 'repos/';

function GitHubApi(user, repo, auth) {
    this.user = user;
    this.repo = repo;
    this.is_auth_enabled = auth.username && auth.password;
    this.auth = "Basic " + Base64.encode(auth.username + ":" + auth.password);
    this.base_url = GITHUB_API_URL_REPOS + this.user + '/' + this.repo + '/';
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
        url: this.base_url + 'issues',
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
        url: this.base_url + 'issues/' + issue_id,
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
        url: this.base_url + 'labels',
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
        url: this.base_url + 'labels/' + label_name,
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
        url: this.base_url + 'labels',
        type: 'POST',
        dataType: 'json',
        data: JSON.stringify(parameters),
        headers: this._get_headers()
    });
}

GitHubApi.prototype.update_label = function(label_name, parameters) {
    var parameters = parameters || {};
    $.ajax({
        url: this.base_url + 'labels/' + label_name,
        type: 'PATCH',
        dataType: 'json',
        data: JSON.stringify(parameters),
        headers: this._get_headers()
    });
}

GitHubApi.prototype.add_labels_to_issue = function(issue_id, labels) {
    $.ajax({
        url: this.base_url + 'issues/' + issue_id + '/labels',
        type: 'POST',
        dataType: 'json',
        data: JSON.stringify(labels),
        headers: this._get_headers()
    });
}

GitHubApi.prototype.get_labels_for_issue = function(issue_id) {
    var response = null;
    $.ajax({
        url: this.base_url + 'issues/' + issue_id + '/labels',
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
        url: this.base_url + 'issues/' + issue_id + '/labels',
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