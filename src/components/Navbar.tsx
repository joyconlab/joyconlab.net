import { useEffect, useState } from 'react';
import ThemeToggle from './ThemeToggle';

interface NavbarProps {
  currentPath: string;
  lang: 'en' | 'ro';
  translations: {
    home: string;
    services: string;
    about: string;
    contact: string;
  };
}

export default function Navbar({ currentPath, lang, translations }: NavbarProps) {
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [activePath, setActivePath] = useState(currentPath);

  const basePath = lang === 'en' ? '' : '/ro';
  const homePath = lang === 'en' ? '/' : '/ro/';

  const navItems = [
    { href: homePath, label: translations.home, key: 'home' },
    { href: `${basePath}/services/`, label: translations.services, key: 'services' },
    { href: `${basePath}/about/`, label: translations.about, key: 'about' },
    { href: `${basePath}/contact/`, label: translations.contact, key: 'contact' },
  ];

  const isActive = (key: string) => {
    const path = activePath.replace(/\/+$/, '') || '/';
    
    if (key === 'home') {
      return path === '/' || path === '/ro' || path === '';
    }
    if (key === 'services') {
      return path === '/services' || path === '/ro/services';
    }
    if (key === 'about') {
      return path === '/about' || path === '/ro/about';
    }
    if (key === 'contact') {
      return path === '/contact' || path === '/ro/contact';
    }
    return false;
  };

  useEffect(() => {
    setActivePath(currentPath);
  }, [currentPath]);

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 50);
    };

    const handlePageLoad = () => {
      setActivePath(window.location.pathname);
      closeMobileMenu();
    };

    window.addEventListener('scroll', handleScroll);
    document.addEventListener('astro:page-load', handlePageLoad);
    
    handleScroll();
    
    return () => {
      window.removeEventListener('scroll', handleScroll);
      document.removeEventListener('astro:page-load', handlePageLoad);
    };
  }, []);

  const toggleMobileMenu = () => {
    setIsMobileMenuOpen(!isMobileMenuOpen);
    document.body.style.overflow = !isMobileMenuOpen ? 'hidden' : '';
  };

  const closeMobileMenu = () => {
    setIsMobileMenuOpen(false);
    document.body.style.overflow = '';
  };

  const getLangSwitchHref = (targetLang: 'en' | 'ro') => {
    const path = activePath.replace(/\/+$/, '') || '/';
    
    if (targetLang === 'en') {
      if (path.startsWith('/ro')) {
        const newPath = path.replace(/^\/ro/, '');
        return newPath || '/';
      }
      return path || '/';
    } else {
      if (path.startsWith('/ro')) {
        return path + '/';
      }
      if (path === '/') {
        return '/ro/';
      }
      return `/ro${path}/`;
    }
  };

  return (
    <nav className={isScrolled ? 'scrolled' : ''}>
      <div className="nav-container">
        <a href={homePath} className="logo" onClick={closeMobileMenu}>
          <span className="joy">JOY</span>
          <span className="con">-CON</span>
          <span className="lab">LAB</span>
        </a>

        <ul className={`nav-links ${isMobileMenuOpen ? 'active' : ''}`}>
          {navItems.map((item) => (
            <li key={item.key}>
              <a 
                href={item.href}
                className={isActive(item.key) ? 'active' : ''}
                onClick={closeMobileMenu}
              >
                {item.label}
              </a>
            </li>
          ))}
        </ul>

        <div className="nav-controls">
          <ThemeToggle />
          
          <div className="lang-toggle">
            <a 
              href={getLangSwitchHref('en')} 
              className={`lang-btn ${lang === 'en' ? 'active' : ''}`} 
              aria-label="English"
              onClick={closeMobileMenu}
            >
              <svg className="flag-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 30">
                <clipPath id="s"><path d="M0,0 v30 h60 v-30 z"/></clipPath>
                <clipPath id="t"><path d="M30,15 h30 v15 z v15 h-30 z h-30 v-15 z v-15 h30 z"/></clipPath>
                <g clipPath="url(#s)">
                  <path d="M0,0 v30 h60 v-30 z" fill="#012169"/>
                  <path d="M0,0 L60,30 M60,0 L0,30" stroke="#fff" strokeWidth="6"/>
                  <path d="M0,0 L60,30 M60,0 L0,30" clipPath="url(#t)" stroke="#C8102E" strokeWidth="4"/>
                  <path d="M30,0 v30 M0,15 h60" stroke="#fff" strokeWidth="10"/>
                  <path d="M30,0 v30 M0,15 h60" stroke="#C8102E" strokeWidth="6"/>
                </g>
              </svg>
            </a>
            <a 
              href={getLangSwitchHref('ro')}
              className={`lang-btn ${lang === 'ro' ? 'active' : ''}`} 
              aria-label="Română"
              onClick={closeMobileMenu}
            >
              <svg className="flag-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 30 20">
                <rect width="10" height="20" fill="#002B7F"/>
                <rect x="10" width="10" height="20" fill="#FCD116"/>
                <rect x="20" width="10" height="20" fill="#CE1126"/>
              </svg>
            </a>
          </div>
        </div>

        <button 
          className={`mobile-menu-btn ${isMobileMenuOpen ? 'active' : ''}`}
          onClick={toggleMobileMenu}
          aria-label="Toggle menu"
        >
          <span />
          <span />
          <span />
        </button>
      </div>
    </nav>
  );
}
