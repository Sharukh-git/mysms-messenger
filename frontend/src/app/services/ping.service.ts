import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class PingService {
  constructor(private http: HttpClient) {}

  pingBackend(): Observable<any> {
    const baseUrl = environment.apiUrl.replace('/api', '');
    return this.http.get(`${baseUrl}/ping`, { responseType: 'text' });
  }
}
