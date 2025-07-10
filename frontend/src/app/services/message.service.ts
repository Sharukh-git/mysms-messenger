import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from '../../environments/environment';
import { Observable } from 'rxjs';

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
    const headers = new HttpHeaders({
      'Accept': 'application/json'
    });

    return this.http.post(`${this.apiUrl}/messages`, { to, body }, {
      withCredentials: true,
      headers: headers
    });
  }

  getMessages(): Observable<Message[]> {
    const headers = new HttpHeaders({
      'Accept': 'application/json'
    });

    return this.http.get<Message[]>(`${this.apiUrl}/messages`, {
      withCredentials: true,
      headers: headers
    });
  }
}
