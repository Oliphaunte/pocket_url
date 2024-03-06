interface CopyToClipboardEvent {
  selector: string
}

export default {
  mounted() {
    this.handleEvent('copy-to-clipboard', ({ selector }: CopyToClipboardEvent) => {
      const element = document.querySelector(selector) as
        | HTMLInputElement
        | HTMLTextAreaElement
        | null

      if (element && 'clipboard' in navigator) {
        navigator.clipboard
          .writeText(element.value)
          .then(() => {
            console.log('Successfully copied to clipboard')
          })
          .catch(err => {
            console.error('Could not copy text to clipboard', err)
          })
      } else {
        alert('Sorry, your browser does not support clipboard copy.')
      }
    })
  },
}
