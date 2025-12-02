import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = {
    assistantSlug: String,
    conversationId: Number,
    leadId: Number
  }

  connect() {
    this.messagesContainer = document.getElementById('chat-messages')
    this.typingIndicator = document.getElementById('chat-typing')
    this.form = document.getElementById('chat-form')
    this.input = document.getElementById('message')

    this.consumer = createConsumer()

    this.subscription = this.consumer.subscriptions.create(
      {
        channel: 'BroadcastMessageAiChannel',
        assistant_slug: this.assistantSlugValue,
        conversation_id: this.conversationIdValue,
        lead_id: this.leadIdValue
      },
      {
        connected: () => {
          console.log('Connected to BroadcastMessageAiChannel')
        },

        received: (data) => {
          this.handleBroadcast(data)
        }
      }
    )

    if (this.form) this.form.addEventListener('submit', (e) => this.sendMessage(e))

    this.scrollToBottom()
  }

  disconnect() {
    if (this.subscription) this.consumer.subscriptions.remove(this.subscription)
  }

  sendMessage(event) {
    event.preventDefault()
    const message = this.input?.value?.trim()
    if (message === '') return

    const payload = {
      assistantSlug: this.assistantSlugValue,
      conversationId: this.conversationIdValue,
      message: message
    }

    this.subscription.perform('speak', payload)

    // I think that I add the message after add on the DB
    //this.appendLocalMessage(message)

    this.input.value = ''
    this.scrollToBottom()
  }

  handleBroadcast(data) {
    switch (data.type) {
      case 'typing_start':
        this.showTypingIndicator()
        break

      case 'typing_end':
        this.hideTypingIndicator()
        break

      case 'user_message_added':
        this.appendMessage(data)
        break

      case 'answered_message':
        this.appendMessage(data, { role: 'assistant' })
        break

      case 'set_conversation_id':
        // server tells us the current (or new) conversation id
        this.conversationIdValue = data.content
        break
      default:
        console.warn('Unknown broadcast', data)
    }
  }

  appendMessage(data, opts = {}) {
    const msg = {
      id: data.id || `remote-${Date.now()}`,
      content: data.content || data.text || '',
      user_name: opts.role === 'assistant' ? (this.element.dataset.assistantName || 'Assistant') : data.user_name || 'Customer',
      created_at: new Date().toISOString(),
      role: opts.role || 'other'
    }

    if (this.messagesContainer.querySelector(`[data-message-id='${msg.id}']`)) return

    this.renderMessage(msg)
  }

  renderMessage(msg) {
    const modifier = msg.role === 'user' || msg.role === 'me' ? 'chat__message--me' : 'chat__message--other'

    const article = document.createElement('article')
    article.className = `chat__message ${modifier}`
    article.setAttribute('data-message-id', msg.id)

    const meta = document.createElement('div')
    meta.className = 'chat__meta'
    meta.innerHTML = `<span class="chat__author">${this.escape(msg.user_name)}</span> <time class="chat__time">${this.shortTime(msg.created_at)}</time>`

    const bubble = document.createElement('div')
    bubble.className = 'chat__bubble'

    const text = document.createElement('div')
    text.className = 'chat__text'
    text.innerHTML = this.renderMarkdownClientSide(msg.content)

    bubble.appendChild(text)
    article.appendChild(meta)
    article.appendChild(bubble)

    this.messagesContainer.appendChild(article)

    // live region should announce but we still scroll
    this.scrollToBottom()
  }

  showTypingIndicator() {
    if (!this.typingIndicator) return
    this.typingIndicator.setAttribute('style', 'visibility: visible')
  }

  hideTypingIndicator() {
    if (!this.typingIndicator) return
    this.typingIndicator.setAttribute('style', 'visibility: hidden')
  }

  scrollToBottom() {
    requestAnimationFrame(() => {
      if (!this.messagesContainer) return
      this.messagesContainer.scrollTop = this.messagesContainer.scrollHeight
    })
  }

  // minimal client-side markdown render for simple links and images
  renderMarkdownClientSide(content) {
    if (!content) return ''

    // escape then replace simple markdown-like url patterns
    const escaped = this.escape(content)

    // detect image URLs
    const imgified = escaped.replace(/(https?:\/\/(?:[\w\-_.~:]+\/?)+\.(?:png|jpg|jpeg|gif|svg))(?![^<]*>)/gi, "<img src='$1' alt='image' style='max-width:100%; height:auto;' />")

    // detect links
    const linkified = imgified.replace(/(https?:\/\/[^\s<]+)/g, "<a href='$1' target='_blank' rel='noopener noreferrer'>$1</a>")

    // preserve newlines
    return linkified.replace(/\n/g, '<br/>')
  }

  escape(html) {
    return String(html).replace(/[&"'<>]/g, function (s) {
      return ({
        '&': '&amp;',
        '"': '&quot;',
        "'": '&#39;',
        '<': '&lt;',
        '>': '&gt;'
      })[s]
    })
  }

  shortTime(iso) {
    try {
      const d = new Date(iso)
      return d.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    } catch (e) {
      return ''
    }
  }
}
