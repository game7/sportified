const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/components/**/*.{rb,erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      colors: {
        'site-header': '#000000',
        primary: 'var(--color-primary)',
        'primary-focus': 'var(--color-primary-focus)',
        'primary-content': 'var(--color-primary-content)',
        secondary: 'var(--color-secondary)',
        accent: 'var(--color-accent)',
        neutral: 'var(--color-neutral, )',
        'neutral-focus': 'var(--color-neutral-focus)',
        'neutral-content': 'var(--color-neutral-content)'
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
