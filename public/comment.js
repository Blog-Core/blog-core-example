(function(){

    // Trim shim for IE8.

    if (typeof String.prototype.trim !== 'function') {

        String.prototype.trim = function() {

            return this.replace(/^\s+|\s+$/g, '');
        };
    }

    var form = document.getElementById('comment-form');

    if (!form) {

        throw new Error('There is no comment form.');
    }

    var authorElem = document.getElementById('comment-author');

    authorElem.onfocus = function() {

        authorElem.className = '';
    };

    var emailElem = document.getElementById('comment-email');

    emailElem.onfocus = function() {

        emailElem.className = '';
    };

    var siteElem = document.getElementById('comment-website');

    siteElem.onfocus = function() {

        siteElem.className = '';
    };

    var messageElem = document.getElementById('comment-message');

    messageElem.onfocus = function() {

        messageElem.className = '';
    };

    var answerElem = document.getElementById('comment-answer');

    answerElem.onfocus = function() {

        answerElem.className = '';
    };

    var errorsElem = document.getElementById('comment-errors');

    function addError(message) {

        var errorElem = document.createElement('li');

        errorElem.innerHTML = message;

        errorsElem.appendChild(errorElem);
    }

    form.onsubmit = function() {

        var errors = [];

        var author = authorElem.value.trim();

        if (author === '') {

            authorElem.className = 'input-error';

            errors.push('Author field is empty.');
        }

        var email = emailElem.value.trim();

        if (email !== '' && !email.match(/[^@]+@[^@]+/)) {

            emailElem.className = 'input-error';

            errors.push('Email field is set but the content does not match the email pattern.');
        }

        var site = siteElem.value.trim();

        if (site !== '' && !site.match(/https?:\/\//)) {

            siteElem.className = 'input-error';

            errors.push('Website is set but the content does not match the URL pattern.');
        }

        var message = messageElem.value.trim();

        if (message === '') {

            messageElem.className = 'input-error';

            errors.push('Message is empty.');
        }

        var answer = answerElem.value.trim();

        if (answer === '') {

            answerElem.className = 'input-error';

            errors.push('Human verification answer is empty.');
        }

        errorsElem.innerHTML = '';

        for (var i = 0; i < errors.length; i++) {

            addError(errors[i]);
        }

        if (errors.length > 0) {

            return false;
        }

        var id = document.getElementById('post-id').value;

        var question = parseInt(document.getElementById('comment-question').value, 10);

        var data = {

            author: author,
            content: message,
            question: question,
            answer: answer,
            email: email,
            site: site
        };

        post(id, data, function(err, response) {

            if (err) {

                addError(err.toString());

            } else {

                if (response.status === 'success') {

                    //window.location.hash = '#comment-' + response.data;

                    window.location.reload(true);

                } else {

                    addError(response.message);
                }
            }
        });

        return false;
    };

    function question(cb) {

        var xhr = new XMLHttpRequest();

        xhr.open('GET', '/api/question', true);

        xhr.onreadystatechange = function() {

            if (xhr.readyState === 4) {

                if (xhr.status === 200) {

                    cb(null, JSON.parse(xhr.responseText));

                } else {

                    cb(new Error('Error while obtaining question.'));
                }
            }
        };

        xhr.send();
    }

    function post(id, data, cb) {

        var xhr = new XMLHttpRequest();

        var url = '/api/post/' + encodeURIComponent(id) + '/comment';

        xhr.open('POST', url, true);

        xhr.setRequestHeader('Content-Type', 'application/json');

        xhr.onreadystatechange = function() {

            if (xhr.readyState === 4) {

                if (xhr.status === 200) {

                    cb(null, JSON.parse(xhr.responseText));

                } else {

                    cb(new Error('Error while posting comment.'));
                }
            }
        };

        xhr.send(JSON.stringify(data));
    }

    window.onload = function() {

        question(function(err, response) {

            if (err) {

                addError(err.toString());

            } else {

                if (response.status === 'success') {

                    document.getElementById('comment-question').value = response.data.id;
                    document.getElementById('comment-answer-label').innerHTML = response.data.question;
                    document.getElementById('comment-form').style.display = 'block';
                }
            }
        });
    };

})();
