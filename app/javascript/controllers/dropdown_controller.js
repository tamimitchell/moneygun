import { Controller } from '@hotwired/stimulus'
import { computePosition, flip, shift, offset, autoUpdate } from '@floating-ui/dom'

export default class extends Controller {
  static values = { closeOnClickOutside: { type: Boolean, default: true } }

  connect() {
    this.handleClickOutside = this.handleClickOutside.bind(this)
    this.cleanup = null
    this.menuPlaceholder = null
    this.isOpen = false

    this.menu = this.element.querySelector('[data-dropdown-menu]')

    document.addEventListener('click', this.handleClickOutside)
  }

  disconnect() {
    document.removeEventListener('click', this.handleClickOutside)
    this.hide()
  }

  toggle() {
    if (this.isOpen) {
      this.hide()
    } else {
      this.show()
    }
  }

  show() {
    if (!this.menu || this.isOpen) return
    this.isOpen = true

    this.menuPlaceholder = document.createComment('dropdown-menu')
    this.menu.parentNode.insertBefore(this.menuPlaceholder, this.menu)
    document.body.appendChild(this.menu)

    this.menu.classList.remove('hidden')

    const reference = this.element.querySelector('[data-action*="dropdown#toggle"]')

    this.cleanup = autoUpdate(reference, this.menu, () => {
      computePosition(reference, this.menu, {
        placement: 'bottom-end',
        strategy: 'fixed',
        middleware: [offset(4), flip({ fallbackPlacements: ['bottom-start', 'top-end', 'top-start'] }), shift({ padding: 8 })]
      }).then(({ x, y }) => {
        Object.assign(this.menu.style, {
          position: 'fixed',
          left: `${x}px`,
          top: `${y}px`
        })
      })
    })
  }

  hide() {
    if (!this.isOpen) return
    this.isOpen = false

    if (this.cleanup) {
      this.cleanup()
      this.cleanup = null
    }

    if (this.menu) {
      this.menu.classList.add('hidden')
    }

    if (this.menuPlaceholder && this.menu) {
      this.menuPlaceholder.parentNode.insertBefore(this.menu, this.menuPlaceholder)
      this.menuPlaceholder.remove()
      this.menuPlaceholder = null
    }
  }

  handleClickOutside(event) {
    if (!this.isOpen) return
    if (this.element.contains(event.target)) return
    if (this.menu && this.menu.contains(event.target)) return

    if (this.closeOnClickOutsideValue) {
      this.hide()
    }
  }
}
