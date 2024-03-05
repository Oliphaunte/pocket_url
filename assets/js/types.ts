import { LiveSocket } from 'phoenix_live_view'

declare global {
  interface Window {
    liveSocket: LiveSocket //Phoenix LiveView
    userToken: string //Phoenix Sockets
  }
}
