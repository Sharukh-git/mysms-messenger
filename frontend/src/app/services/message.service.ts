import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment';
import { Observable } from 'rxjs';

// Message interface
export interface Message {
  to: string;
  body: string;
  created_at: string;
}

@Injectable({
  providedIn: 'root'
})
export class MessageService {
  private apiUrl = environment.apiUrl;

  constructor(private http: HttpClient) {}

  sendMessage(to: string, body: string): Observable<any> {
    return this.http.post(`${this.apiUrl}/messages`, { to, body }, {
      withCredentials: true
    });
  }

  // ✅ Properly typed to fix TS2769 error
  getMessages(): Observable<Message[]> {
    return this.http.get<Message[]>(`${this.apiUrl}/messages`, {
      withCredentials: true
    });
  }
}
