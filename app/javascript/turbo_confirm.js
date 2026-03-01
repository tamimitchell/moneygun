// Replace default browser confirm() with a styled <dialog> for data-turbo-confirm.
// See: https://boringrails.com/articles/data-turbo-confirm-beautiful-dialog/
import { Turbo } from '@hotwired/turbo'

Turbo.config.forms.confirm = (message, element, submitter) => {
  const dialog = document.getElementById('turbo-confirm-dialog')
  const titleEl = document.getElementById('turbo-confirm-title')
  const descriptionEl = document.getElementById('turbo-confirm-description')
  const textInput = document.getElementById('turbo-confirm-text-input')
  const acceptBtn = document.getElementById('turbo-confirm-accept')
  const rejectBtn = document.getElementById('turbo-confirm-reject')

  if (!dialog) return Promise.resolve(confirm(message))

  // AbortController for clean teardown of all listeners
  const controller = new AbortController()
  const { signal } = controller

  // Read data attributes — check submitter first, fall back to element
  const data = submitter?.dataset || {}
  const elementData = element.dataset || {}

  const description = data.turboConfirmDescription || elementData.turboConfirmDescription
  const requiredText = data.turboConfirmText || elementData.turboConfirmText
  const acceptLabel = data.turboConfirmAccept || elementData.turboConfirmAccept
  const rejectLabel = data.turboConfirmReject || elementData.turboConfirmReject

  // Populate title with the confirm message
  titleEl.textContent = message

  // Description
  if (description) {
    descriptionEl.textContent = description
    descriptionEl.classList.remove('hidden')
    dialog.setAttribute('aria-describedby', 'turbo-confirm-description')
  } else {
    descriptionEl.textContent = ''
    descriptionEl.classList.add('hidden')
    dialog.removeAttribute('aria-describedby')
  }

  // Text confirmation input
  if (requiredText) {
    textInput.value = ''
    textInput.placeholder = requiredText
    textInput.classList.remove('hidden')
    acceptBtn.disabled = true

    textInput.addEventListener(
      'input',
      () => {
        acceptBtn.disabled = textInput.value !== requiredText
      },
      { signal }
    )

    textInput.addEventListener(
      'keydown',
      event => {
        if (event.key === 'Enter' && !acceptBtn.disabled) {
          event.preventDefault()
          dialog.close('confirm')
        }
      },
      { signal }
    )
  } else {
    textInput.value = ''
    textInput.classList.add('hidden')
    acceptBtn.disabled = false
  }

  // Custom button labels (fall back to existing text from the partial)
  const defaultAcceptLabel = acceptBtn.textContent.trim()
  const defaultRejectLabel = rejectBtn.textContent.trim()
  acceptBtn.textContent = acceptLabel || defaultAcceptLabel
  rejectBtn.textContent = rejectLabel || defaultRejectLabel

  // Close on backdrop click (click lands on <dialog> itself, not the modal-box)
  dialog.addEventListener(
    'click',
    event => {
      if (event.target === dialog) dialog.close('cancel')
    },
    { signal }
  )

  dialog.showModal()

  // Focus: text input if present, otherwise confirm button
  if (requiredText) {
    textInput.focus()
  } else {
    acceptBtn.focus()
  }

  return new Promise(resolve => {
    dialog.addEventListener(
      'close',
      () => {
        controller.abort()
        acceptBtn.disabled = false
        acceptBtn.textContent = defaultAcceptLabel
        rejectBtn.textContent = defaultRejectLabel
        resolve(dialog.returnValue === 'confirm')
      },
      { once: true }
    )
  })
}
