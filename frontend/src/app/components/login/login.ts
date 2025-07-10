import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpClient } from '@angular/common/http';
import { Router, RouterModule } from '@angular/router';
import { environment } from '../../../environments/environment';
import { PingService } from '../../services/ping.service';


@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './login.html',
  styleUrls: ['./login.scss']
})
export class LoginComponent {
  email = '';
  password = '';
  loading = false;
  errorMessage = '';
  showPassword = false;
  isBackendReady = false;
  isCheckingBackend = true;


  constructor(private http: HttpClient, private router: Router, private pingService: PingService) {}

  togglePasswordVisibility() {
    this.showPassword = !this.showPassword;
  }

  onSubmit() {
    this.loading = true;
    this.errorMessage = '';

    this.http
      .post(`${environment.apiUrl}/login`, {
        user: { email: this.email, password: this.password }
      }, { withCredentials: true })
      .subscribe({
        next: () => {
          this.router.navigate(['/dashboard']);
        },
        error: (error) => {
          this.loading = false;
          this.errorMessage = error.error?.error || 'Login failed.';
        }
      });
  }

  ngOnInit(): void {
  this.pingService.pingBackend().subscribe({
    next: () => {
      this.isBackendReady = true;
      this.isCheckingBackend = false;
    },
    error: () => {
      this.isBackendReady = false;
      this.isCheckingBackend = false;
    }
  });
 }

}
