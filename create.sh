#!/bin/bash

cat > src/components/Navbar.tsx << 'EOF'
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
EOF

cat > src/components/Footer.astro << 'EOF'
---
interface Props {
  lang: 'en' | 'ro';
  translations: {
    description: string;
    servicesTitle: string;
    quickLinksTitle: string;
    copyright: string;
  };
  navTranslations: {
    home: string;
    services: string;
    about: string;
    contact: string;
  };
}

const { lang, translations, navTranslations } = Astro.props;
const basePath = lang === 'en' ? '' : '/ro';
const homePath = lang === 'en' ? '/' : '/ro/';
---

<footer>
  <div class="container">
    <div class="footer-content">
      <div class="footer-brand">
        <h3>
          <span class="joy">JOY</span><span class="con">-CON</span>{' '}
          <span class="lab">LAB</span>
        </h3>
        <p>{translations.description}</p>
        <div class="social-links">
          <a 
            href="https://instagram.com/joyconlab" 
            class="social-link" 
            target="_blank" 
            rel="noopener noreferrer"
            aria-label="Instagram"
          >
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="2" y="2" width="20" height="20" rx="5" ry="5"></rect>
              <path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"></path>
              <line x1="17.5" y1="6.5" x2="17.51" y2="6.5"></line>
            </svg>
          </a>
          <a 
            href="https://www.ebay.com/usr/joyconlab" 
            class="social-link" 
            target="_blank" 
            rel="noopener noreferrer"
            aria-label="eBay"
          >
            <svg viewBox="-143 145 512 512" fill="currentColor">
              <path d="M141.9,408.8c0,5.7,1.2,13,9.5,13c14.6,0,12.3-18.2,12.3-27.2C151.4,395.3,141.9,394.3,141.9,408.8z"/>
              <path d="M17.4,393.6C-3.3,393.6-3,404.5-3,410.4h41.5C38.5,403.6,39.3,393.6,17.4,393.6z"/>
              <path d="M-143,145v512h512V145H-143z M17.5,456.2c-58.7,0-66.2-15.8-66.2-38.5c0-19.6,6.4-36.5,66.2-36.5c14.2,0,25.6,1.1,34.1,2.8
                c5.3,0.9,9.8,2,13.6,3.8c17.6,6.8,19.9,19.2,18.7,34H65.2H-2.9c0,8.6,0.4,21.4,20.4,21.4c16.2,0,19.5-6.9,19.5-13.1h14.6H52h13.2
                h18c-0.4,8-6.3,14.1-17.2,18.5c-0.4,0.4-0.4,0.4-0.7,0.4c-3.9,1.8-8.3,3.2-13.2,4.2C42.7,454.8,31,456.2,17.5,456.2z M110.3,467.5
                c-9.8,0-16.6-2.8-21-10.7h-0.4v8.9H65.3v-13.8l0.6-0.3c0.8,0,1-0.1,1.7-0.8c5.6-2.3,10-5.1,13.1-8.4c3.4-3.6,5.2-7.7,5.4-12.4
                c0.1-1.6-1.1-3-2.7-3h-0.1h-18v-2.4H84c1.5,0,2.7-1.2,2.8-2.7c0.6-7.8,0.3-15.1-2.6-21.5c-2.9-6.5-8.4-11.8-17.9-15.5
                c-0.3-0.2-0.7-0.3-1.1-0.5v-35.7H90v42.9h0.4c5.3-6.9,11.3-9.3,20.3-9.3c6.1,0,10.5,1.3,13.9,3.6c-3.1,2.3-5.5,5.3-7.2,9
                c-1.8,3.9-2.7,8.7-2.7,14.4v0.1c0,3.8,0.4,7.5,1.4,10.9c0.4,1.4,0.9,2.7,1.5,4.1c3,6.8,8.5,11.9,17.1,13.7h0.1l0.3,0.1
                C133.9,452.7,129.6,467.5,110.3,467.5z M166,434.5l-1.1-10.9h-0.4c-5.3,8.2-12.3,12.3-23.2,12.3c-2.3,0-4.2,0-6-0.4
                c-12.8-2.7-17.7-13.4-17.7-25.8c0-10.6,3.3-17.5,9.4-21.6c8.7-6.2,22.6-6.6,36.9-6.2v-6.6c0-6.8-1-12-10.1-12
                c-9,0-9.4,6.2-9.4,12.7h-24.8c0-10,3.4-16.4,9.4-19.9c5.6-4.1,13.9-5.5,23.4-5.5c2.8,0,5.4,0.2,7.8,0.4l0.9,1.7l24.9,46.1l2.5,4.6
                V419c0,5.2,0.7,10.3,1.1,15.5H166z M231.1,416.3v40.2h-32.7v-40.2l-10.1-18.9l-24.9-46.1l-5.9-10.9h35.7l23.4,49l25.2-49h33.1
                L231.1,416.3z"/>
              <path d="M100.2,396.7C90,396.7,90,408.1,90,424.1c0,20.7,1.5,29.2,10.1,29.2c9.1,0,10.5-8.6,10.5-29.2
                C110.7,408.1,111.1,396.7,100.2,396.7z"/>
            </svg>
          </a>
        </div>
      </div>
      
      <div class="footer-links">
        <h4>{translations.servicesTitle}</h4>
        <ul>
          <li><a href={`${basePath}/services/`}>Switch Modding</a></li>
          <li><a href={`${basePath}/services/`}>Joy-Con Repair</a></li>
          <li><a href={`${basePath}/services/`}>Other Consoles</a></li>
        </ul>
      </div>
      
      <div class="footer-links">
        <h4>{translations.quickLinksTitle}</h4>
        <ul>
          <li><a href={homePath}>{navTranslations.home}</a></li>
          <li><a href={`${basePath}/about/`}>{navTranslations.about}</a></li>
          <li><a href={`${basePath}/contact/`}>{navTranslations.contact}</a></li>
        </ul>
      </div>
    </div>
    <div class="footer-bottom">
      <p>{translations.copyright}</p>
    </div>
  </div>
</footer>

<style>
  .social-link svg {
    width: 20px;
    height: 20px;
  }
</style>
EOF

cat > src/pages/index.astro << 'EOF'
---
import Layout from '../layouts/Layout.astro';
import ServiceCard from '../components/ServiceCard';
import ContactCard from '../components/ContactCard';
import AnimatedSection from '../components/AnimatedSection';
import { translations } from '../i18n';

const t = translations.en;
---

<Layout 
  title="Joy-Con Lab | Professional Nintendo Switch Modding" 
  description="Expert Nintendo Switch modding services in Bucharest. HWFLY, PicoFly installation, Joy-Con repair, thermal maintenance with 90-day warranty."
  lang="en"
  translations={t}
>
  <AnimatedSection client:load>
    <section class="services" id="services">
      <div class="container">
        <div class="section-header">
          <h1 class="fade-in">{t.services.title}</h1>
          <p class="fade-in stagger-1">{t.services.subtitle}</p>
        </div>
        <div class="services-grid">
          {t.services.items.map((service, index) => (
            <ServiceCard 
              icon={service.icon}
              title={service.title}
              description={service.description}
              features={service.features}
              index={index}
              client:visible
            />
          ))}
        </div>
      </div>
    </section>

    <section class="about" id="about">
      <div class="container">
        <div class="about-content">
          <div class="about-text">
            <h2 class="fade-in-left">{t.about.title}</h2>
            <p class="fade-in-left stagger-1">{t.about.p1}</p>
            <p class="fade-in-left stagger-2">{t.about.p2}</p>
            <div class="about-stats">
              {t.about.stats.map((stat, index) => (
                <div class={`stat fade-in stagger-${index + 1}`}>
                  <div class="stat-number" data-count={stat.value} data-suffix={stat.suffix}>0</div>
                  <div class="stat-label">{stat.label}</div>
                </div>
              ))}
            </div>
          </div>
          <div class="about-image fade-in-right">
            <div class="about-visual">
              <div class="joycon-left"></div>
              <div class="joycon-right"></div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="contact" id="contact">
      <div class="container">
        <div class="section-header">
          <h2 class="fade-in">{t.contact.title}</h2>
          <p class="fade-in stagger-1">{t.contact.subtitle}</p>
        </div>
        <div class="contact-grid">
          <ContactCard 
            icon="✉️"
            title={t.contact.email}
            content="contact@joyconlab.net"
            href="mailto:contact@joyconlab.net"
            index={0}
            client:visible
          />
          <ContactCard 
            icon="📸"
            title={t.contact.instagram}
            content="@joyconlab"
            href="https://instagram.com/joyconlab"
            isExternal={true}
            index={1}
            client:visible
          />
          <ContactCard 
            icon="📍"
            title={t.contact.location}
            content={t.contact.locationValue}
            index={2}
            client:visible
          />
        </div>
      </div>
    </section>
  </AnimatedSection>
</Layout>
EOF

cat > src/pages/services.astro << 'EOF'
---
import Layout from '../layouts/Layout.astro';
import ServiceCard from '../components/ServiceCard';
import AnimatedSection from '../components/AnimatedSection';
import { translations } from '../i18n';

const t = translations.en;
---

<Layout 
  title="Services | Joy-Con Lab" 
  description="Professional Nintendo Switch modding services. HWFLY, PicoFly installation, Joy-Con repair, thermal maintenance."
  lang="en"
  translations={t}
>
  <AnimatedSection client:load>
    <section class="services" id="services">
      <div class="container">
        <div class="section-header">
          <h1 class="fade-in">{t.services.title}</h1>
          <p class="fade-in stagger-1">{t.services.subtitle}</p>
        </div>
        <div class="services-grid">
          {t.services.items.map((service, index) => (
            <ServiceCard 
              icon={service.icon}
              title={service.title}
              description={service.description}
              features={service.features}
              index={index}
              client:visible
            />
          ))}
        </div>
      </div>
    </section>
  </AnimatedSection>
</Layout>
EOF

cat > src/pages/about.astro << 'EOF'
---
import Layout from '../layouts/Layout.astro';
import AnimatedSection from '../components/AnimatedSection';
import { translations } from '../i18n';

const t = translations.en;
---

<Layout 
  title="About | Joy-Con Lab" 
  description="Learn about Joy-Con Lab - professional Nintendo Switch modding experts in Bucharest, Romania."
  lang="en"
  translations={t}
>
  <AnimatedSection client:load>
    <section class="about" id="about">
      <div class="container">
        <div class="about-content">
          <div class="about-text">
            <h1 class="fade-in-left">{t.about.title}</h1>
            <p class="fade-in-left stagger-1">{t.about.p1}</p>
            <p class="fade-in-left stagger-2">{t.about.p2}</p>
            <div class="about-stats">
              {t.about.stats.map((stat, index) => (
                <div class={`stat fade-in stagger-${index + 1}`}>
                  <div class="stat-number" data-count={stat.value} data-suffix={stat.suffix}>0</div>
                  <div class="stat-label">{stat.label}</div>
                </div>
              ))}
            </div>
          </div>
          <div class="about-image fade-in-right">
            <div class="about-visual">
              <div class="joycon-left"></div>
              <div class="joycon-right"></div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </AnimatedSection>
</Layout>
EOF

cat > src/pages/contact.astro << 'EOF'
---
import Layout from '../layouts/Layout.astro';
import ContactCard from '../components/ContactCard';
import AnimatedSection from '../components/AnimatedSection';
import { translations } from '../i18n';

const t = translations.en;
---

<Layout 
  title="Contact | Joy-Con Lab" 
  description="Get in touch with Joy-Con Lab for Nintendo Switch modding services in Bucharest, Romania."
  lang="en"
  translations={t}
>
  <AnimatedSection client:load>
    <section class="contact" id="contact">
      <div class="container">
        <div class="section-header">
          <h1 class="fade-in">{t.contact.title}</h1>
          <p class="fade-in stagger-1">{t.contact.subtitle}</p>
        </div>
        <div class="contact-grid">
          <ContactCard 
            icon="✉️"
            title={t.contact.email}
            content="contact@joyconlab.net"
            href="mailto:contact@joyconlab.net"
            index={0}
            client:visible
          />
          <ContactCard 
            icon="📸"
            title={t.contact.instagram}
            content="@joyconlab"
            href="https://instagram.com/joyconlab"
            isExternal={true}
            index={1}
            client:visible
          />
          <ContactCard 
            icon="📍"
            title={t.contact.location}
            content={t.contact.locationValue}
            index={2}
            client:visible
          />
        </div>
      </div>
    </section>
  </AnimatedSection>
</Layout>
EOF

cat > src/pages/ro/index.astro << 'EOF'
---
import Layout from '../../layouts/Layout.astro';
import ServiceCard from '../../components/ServiceCard';
import ContactCard from '../../components/ContactCard';
import AnimatedSection from '../../components/AnimatedSection';
import { translations } from '../../i18n';

const t = translations.ro;
---

<Layout 
  title="Joy-Con Lab | Modare Profesională Nintendo Switch" 
  description="Servicii expert de modare Nintendo Switch în București. Instalare HWFLY, PicoFly, reparații Joy-Con, mentenanță termică cu garanție 90 de zile."
  lang="ro"
  translations={t}
>
  <AnimatedSection client:load>
    <section class="services" id="services">
      <div class="container">
        <div class="section-header">
          <h1 class="fade-in">{t.services.title}</h1>
          <p class="fade-in stagger-1">{t.services.subtitle}</p>
        </div>
        <div class="services-grid">
          {t.services.items.map((service, index) => (
            <ServiceCard 
              icon={service.icon}
              title={service.title}
              description={service.description}
              features={service.features}
              index={index}
              client:visible
            />
          ))}
        </div>
      </div>
    </section>

    <section class="about" id="about">
      <div class="container">
        <div class="about-content">
          <div class="about-text">
            <h2 class="fade-in-left">{t.about.title}</h2>
            <p class="fade-in-left stagger-1">{t.about.p1}</p>
            <p class="fade-in-left stagger-2">{t.about.p2}</p>
            <div class="about-stats">
              {t.about.stats.map((stat, index) => (
                <div class={`stat fade-in stagger-${index + 1}`}>
                  <div class="stat-number" data-count={stat.value} data-suffix={stat.suffix}>0</div>
                  <div class="stat-label">{stat.label}</div>
                </div>
              ))}
            </div>
          </div>
          <div class="about-image fade-in-right">
            <div class="about-visual">
              <div class="joycon-left"></div>
              <div class="joycon-right"></div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <section class="contact" id="contact">
      <div class="container">
        <div class="section-header">
          <h2 class="fade-in">{t.contact.title}</h2>
          <p class="fade-in stagger-1">{t.contact.subtitle}</p>
        </div>
        <div class="contact-grid">
          <ContactCard 
            icon="✉️"
            title={t.contact.email}
            content="contact@joyconlab.net"
            href="mailto:contact@joyconlab.net"
            index={0}
            client:visible
          />
          <ContactCard 
            icon="📸"
            title={t.contact.instagram}
            content="@joyconlab"
            href="https://instagram.com/joyconlab"
            isExternal={true}
            index={1}
            client:visible
          />
          <ContactCard 
            icon="📍"
            title={t.contact.location}
            content={t.contact.locationValue}
            index={2}
            client:visible
          />
        </div>
      </div>
    </section>
  </AnimatedSection>
</Layout>
EOF

cat > src/pages/ro/services.astro << 'EOF'
---
import Layout from '../../layouts/Layout.astro';
import ServiceCard from '../../components/ServiceCard';
import AnimatedSection from '../../components/AnimatedSection';
import { translations } from '../../i18n';

const t = translations.ro;
---

<Layout 
  title="Servicii | Joy-Con Lab" 
  description="Servicii profesionale de modare Nintendo Switch. Instalare HWFLY, PicoFly, reparații Joy-Con, mentenanță termică."
  lang="ro"
  translations={t}
>
  <AnimatedSection client:load>
    <section class="services" id="services">
      <div class="container">
        <div class="section-header">
          <h1 class="fade-in">{t.services.title}</h1>
          <p class="fade-in stagger-1">{t.services.subtitle}</p>
        </div>
        <div class="services-grid">
          {t.services.items.map((service, index) => (
            <ServiceCard 
              icon={service.icon}
              title={service.title}
              description={service.description}
              features={service.features}
              index={index}
              client:visible
            />
          ))}
        </div>
      </div>
    </section>
  </AnimatedSection>
</Layout>
EOF

cat > src/pages/ro/about.astro << 'EOF'
---
import Layout from '../../layouts/Layout.astro';
import AnimatedSection from '../../components/AnimatedSection';
import { translations } from '../../i18n';

const t = translations.ro;
---

<Layout 
  title="Despre | Joy-Con Lab" 
  description="Află despre Joy-Con Lab - experți în modare Nintendo Switch în București, România."
  lang="ro"
  translations={t}
>
  <AnimatedSection client:load>
    <section class="about" id="about">
      <div class="container">
        <div class="about-content">
          <div class="about-text">
            <h1 class="fade-in-left">{t.about.title}</h1>
            <p class="fade-in-left stagger-1">{t.about.p1}</p>
            <p class="fade-in-left stagger-2">{t.about.p2}</p>
            <div class="about-stats">
              {t.about.stats.map((stat, index) => (
                <div class={`stat fade-in stagger-${index + 1}`}>
                  <div class="stat-number" data-count={stat.value} data-suffix={stat.suffix}>0</div>
                  <div class="stat-label">{stat.label}</div>
                </div>
              ))}
            </div>
          </div>
          <div class="about-image fade-in-right">
            <div class="about-visual">
              <div class="joycon-left"></div>
              <div class="joycon-right"></div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </AnimatedSection>
</Layout>
EOF

cat > src/pages/ro/contact.astro << 'EOF'
---
import Layout from '../../layouts/Layout.astro';
import ContactCard from '../../components/ContactCard';
import AnimatedSection from '../../components/AnimatedSection';
import { translations } from '../../i18n';

const t = translations.ro;
---

<Layout 
  title="Contact | Joy-Con Lab" 
  description="Contactează Joy-Con Lab pentru servicii de modare Nintendo Switch în București, România."
  lang="ro"
  translations={t}
>
  <AnimatedSection client:load>
    <section class="contact" id="contact">
      <div class="container">
        <div class="section-header">
          <h1 class="fade-in">{t.contact.title}</h1>
          <p class="fade-in stagger-1">{t.contact.subtitle}</p>
        </div>
        <div class="contact-grid">
          <ContactCard 
            icon="✉️"
            title={t.contact.email}
            content="contact@joyconlab.net"
            href="mailto:contact@joyconlab.net"
            index={0}
            client:visible
          />
          <ContactCard 
            icon="📸"
            title={t.contact.instagram}
            content="@joyconlab"
            href="https://instagram.com/joyconlab"
            isExternal={true}
            index={1}
            client:visible
          />
          <ContactCard 
            icon="📍"
            title={t.contact.location}
            content={t.contact.locationValue}
            index={2}
            client:visible
          />
        </div>
      </div>
    </section>
  </AnimatedSection>
</Layout>
EOF

rm -f src/pages/en/index.astro src/pages/en/services.astro src/pages/en/about.astro src/pages/en/contact.astro
rmdir src/pages/en 2>/dev/null || true

echo "Done! Fixed:"
echo "  ✓ Navigation now works correctly"
echo "  ✓ eBay logo updated with proper SVG"
echo "  ✓ Removed /en/ redirects (root is English)"
echo ""
echo "Routes:"
echo "  / /services/ /about/ /contact/ → English"
echo "  /ro/ /ro/services/ /ro/about/ /ro/contact/ → Romanian"