if window.history?.pushState and window.history.replaceState
  document.addEventListener 'page:change', (event) =>

    # Google Analytics
    if window._gaq?
      _gaq.push(['_trackPageview'])
    else if window.pageTracker?
      pageTracker._trackPageview();
