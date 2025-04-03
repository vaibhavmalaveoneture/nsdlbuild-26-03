import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class UsbTokenService {
  private socket!: WebSocket;
  private messageSubject = new BehaviorSubject<string | null>(null);
  public messages$: Observable<string | null> = this.messageSubject.asObservable();

  constructor() { }

  connect(): void {
    this.socket = new WebSocket("ws://127.0.0.1:8888");

    this.socket.onopen = () => {
      alert('Connected to NSDL eSigner!');
    };

    this.socket.onclose = () => {
      alert('Disconnected from NSDL eSigner.');
    };

    this.socket.onmessage = (event) => {
      this.messageSubject.next(event.data);
    };

    this.socket.onerror = (event) => {
      alert('An error has occurred from NSDL eSigner!');
    };
  }

  sendMessage(message: string): void {
    if (this.socket && this.socket.readyState === WebSocket.OPEN) {
      this.socket.send(message);
    } else {
      alert('WebSocket is not connected.');
    }
  }
}
