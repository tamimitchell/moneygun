import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    this.previouslyFocusedElement = document.activeElement
    this.open()
    this.boundHandleClose = this.handleClose.bind(this)
    this.element.addEventListener('close', this.boundHandleClose)
  }

  disconnect() {
    this.element.removeEventListener('close', this.boundHandleClose)
  }

  hideOnSubmit(e) {
    if (e.detail.success) {
      this.close()
    }
  }

  open() {
    this.element.showModal()
    document.body.classList.add('overflow-hidden')

    const focusable = this.element.querySelector(
      'input:not([type="hidden"]):not([disabled]), textarea:not([disabled]), select:not([disabled]), a[href], button:not([disabled])'
    )
    if (focusable) {
      focusable.focus()
    }
  }

  close() {
    this.element.close()
  }

  handleClose() {
    document.body.classList.remove('overflow-hidden')

    const frame = document.getElementById('modal')
    if (frame) {
      frame.removeAttribute('src')
      frame.innerHTML = ''
    }

    if (this.previouslyFocusedElement && this.previouslyFocusedElement.focus) {
      this.previouslyFocusedElement.focus()
    }
  }

  trackMousedown(event) {
    this.mousedownTarget = event.target
  }

  clickOutside(event) {
    if (event.target === this.element && this.mousedownTarget === this.element) {
      this.close()
    }
  }
}
