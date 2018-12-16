(function() {
    var RECAPTCHA_SITE_KEY = '6LcN8CITAAAAAL7vmmAmOoZrJ6uaFUjkc-20wnkc';
    var RECAPTCHA_THEME = 'dark';
    var RECAPTCHA_SIZE = 'normal';
    var PAGE_BG_COLOR = '#2E3B41';

    function waitReady() {
 
        window.webkit.messageHandlers.reCaptcha.postMessage(["readyState", document.readyState]);
 
        if (document.readyState == 'complete')
            documentReady();
        else
            setTimeout(waitReady, 100);
    }

    function documentReady() {
 
        window.webkit.messageHandlers.reCaptcha.postMessage(["documentReady"]);
 
        while (document.body.lastChild) {
            document.body.removeChild(document.body.lastChild);
        }
 
        var div = document.createElement('div');

        document.body.style.backgroundColor = PAGE_BG_COLOR;
        document.body.appendChild(div);

        var meta = document.createElement('meta');

        meta.setAttribute('name', 'viewport');
        meta.setAttribute('content', 'width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0');

        document.head.appendChild(meta);

        showCaptcha(div);
    }

    function showCaptcha(el) {
        try {
            // For config see: https://developers.google.com/recaptcha/docs/display#config
            grecaptcha.render(el, {
                'sitekey': RECAPTCHA_SITE_KEY,
                'size': RECAPTCHA_SIZE,
                'theme': RECAPTCHA_THEME,
                'callback': captchaSolved,
                'expired-callback': captchaExpired,
                'error-callback': captchaError
            });

            window.webkit.messageHandlers.reCaptcha.postMessage(["reCaptchaDidLoad"]);
        } catch (_) {
            window.setTimeout(function() { showCaptcha(el) }, 50);
        }
    }

    function captchaSolved(response) {
        window.webkit.messageHandlers.reCaptcha.postMessage(["reCaptchaDidSolved", response]);
    }

    function captchaExpired() {
        window.webkit.messageHandlers.reCaptcha.postMessage(["reCaptchaDidExpired"]);
    }
 
    function captchaError() {
        window.webkit.messageHandlers.reCaptcha.postMessage(["reCaptchaError"]);
    }

    waitReady();
})();
