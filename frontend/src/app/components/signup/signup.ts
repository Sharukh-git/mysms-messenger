import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpClient } from '@angular/common/http';
import { Router, RouterModule } from '@angular/router'; 
import { environment } from '../../../environments/environment';

@Component({
  selector: 'app-signup',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  templateUrl: './signup.html',
  styleUrls: ['./signup.scss']
})
export class SignupComponent {
  email = '';
  password = '';
  confirmPassword = '';
  loading = false;
  errorMessage = '';

  // Password visibility
  showPassword = false;

  // Password validation flags
  passwordLength = false;
  hasUppercase = false;
  hasNumber = false;
  hasSpecial = false;
  isPasswordStrong = false;

  constructor(private http: HttpClient, private router: Router) {}

  togglePasswordVisibility() {
    this.showPassword = !this.showPassword;
  }

  checkPasswordStrength() {
    this.passwordLength = this.password.length >= 8;
    this.hasUppercase = /[A-Z]/.test(this.password);
    this.hasNumber = /[0-9]/.test(this.password);
    this.hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(this.password);
    this.isPasswordStrong =
      this.passwordLength &&
      this.hasUppercase &&
      this.hasNumber &&
      this.hasSpecial;
  }

  onSubmit() {
    if (!this.isPasswordStrong) {
      this.errorMessage = 'Password does not meet strength requirements.';
      return;
    }

    if (this.password !== this.confirmPassword) {
      this.errorMessage = 'Passwords do not match.';
      return;
    }

    this.loading = true;
    this.errorMessage = '';

    this.http
      .post(`${environment.apiUrl}/signup`, {
        user: { email: this.email, password: this.password }
      }, { withCredentials: true })
      .subscribe({
        next: () => {
          this.router.navigate(['/dashboard']);
        },
        error: (error) => {
          this.loading = false;
          this.errorMessage = error.error?.errors?.[0] || 'Signup failed.';
        }
      });
  }
}
