import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { MessageFormComponent } from '../components/message-form/message-form';
import { MessageListComponent } from '../components/message-list/message-list';
import { environment } from '../../environments/environment';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [MessageFormComponent, MessageListComponent],
  templateUrl: './dashboard.html',
  styleUrls: ['./dashboard.scss']
})
export class DashboardComponent {
  constructor(private http: HttpClient, private router: Router) {}

  logout() {
    this.http
      .delete(`${environment.apiUrl}/logout`, { withCredentials: true })
      .subscribe({
        next: () => {
          this.router.navigate(['/login']);
        },
        error: () => {
          alert('Logout failed. Try again.');
        }
      });
  }
}
