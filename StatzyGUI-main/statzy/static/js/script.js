
function setActiveLink() {
    const currentPageUrl = window.location.href;
    const links = document.querySelectorAll('a');

    links.forEach(link => {
      if (link.href === currentPageUrl) {
        link.classList.add('active-link');
      } else {
        link.classList.remove('active-link');
      }
    });
  }

  document.addEventListener('DOMContentLoaded', setActiveLink);