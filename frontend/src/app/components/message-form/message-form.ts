import { Component } from '@angular/core';
import { NgForm, FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { MessageService } from '../../services/message.service';

@Component({
  selector: 'app-message-form',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './message-form.html',
  styleUrls: ['./message-form.scss']
})
export class MessageFormComponent {
  to: string = '';
  body: string = '';
  isLoading = false;
  hasInvalidChars = false;
  phoneBlurred = false;
  messageBlurred = false;
  formValid = false;

  constructor(private messageService: MessageService) {}

  // Validate phone number input (allows digits and optional leading '+')
  validateInput(): void {
    const regex = /^(\+)?\d*$/;
    this.hasInvalidChars = !regex.test(this.to);
  }

  // Set flags when fields lose focus
  onPhoneBlur(): void {
    this.phoneBlurred = true;
  }

  onMessageBlur(): void {
    this.messageBlurred = true;
  }

  // Count numeric digits (excluding '+')
  getDigitCount(): number {
    return this.to.replace(/\D/g, '').length;
  }

  // Validate phone number length (10–15 digits)
  isPhoneDigitLengthValid(): boolean {
    const count = this.getDigitCount();
    return count >= 10 && count <= 15;
  }

  // Check full form validity
  isFormValid(): boolean {
    return (
      !this.hasInvalidChars &&
      this.isPhoneDigitLengthValid() &&
      this.body.trim().length >= 2
    );
  }

  // Update validity on every input
  checkFormValidity(): void {
    this.formValid = this.isFormValid();
  }

  // Reset form state
  clearForm(form: NgForm): void {
    this.to = '';
    this.body = '';
    this.hasInvalidChars = false;
    this.phoneBlurred = false;
    this.messageBlurred = false;
    this.formValid = false;
    form.resetForm();
  }

  // Handle form submit
  onSubmit(form: NgForm): void {
    this.phoneBlurred = true;

    if (!this.isFormValid()) return;

    this.isLoading = true;

    this.messageService.sendMessage(this.to.trim(), this.body.trim()).subscribe({
      next: () => {
        alert('Message sent!');
        window.location.reload();
      },
      error: (err) => {
        console.error('Error sending message', err);
        alert('Failed to send message.');
        window.location.reload();
      }
    });
  }
}
