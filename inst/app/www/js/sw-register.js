window.addEventListener('load', () => {
  if ('serviceWorker' in navigator) {
    var pathname;
    if (window.location.pathname === '/') {
      pathname = 'www/';
    } else {
      pathname = window.location.pathname;
    }
    navigator.serviceWorker
      .register(pathname + 'service-worker.js', { scope: pathname})
      .then(function() { console.log('Service Worker Registered'); });
  }
});
