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

  // Validates character pattern live (for non-numeric)
  validateInput(): void {
    const regex = /^(\+)?\d*$/;
    this.hasInvalidChars = !regex.test(this.to);
  }

  // On blur, enable length validation
  onPhoneBlur(): void {
    this.phoneBlurred = true;
  }

  onMessageBlur(): void {
    this.messageBlurred = true;
  }


  // Get count of digits (excluding '+')
  getDigitCount(): number {
    return this.to.replace(/\D/g, '').length;
  }

  // Is digit length valid (10–15)?
  isPhoneDigitLengthValid(): boolean {
    const count = this.getDigitCount();
    return count >= 10 && count <= 15;
  }

  isFormValid(): boolean {
    return !this.hasInvalidChars && this.isPhoneDigitLengthValid() && this.body.trim().length >= 2;
  }

  checkFormValidity(): void {
  this.formValid = this.isFormValid();
  }

  clearForm(form: NgForm): void {
    this.to = '';
    this.body = '';
    this.hasInvalidChars = false;
    this.phoneBlurred = false;
    this.messageBlurred = false;
    this.formValid = false;
    form.resetForm();
  }

  onSubmit(form: NgForm): void {
    this.phoneBlurred = true;

    if (!this.isFormValid()) return;

    this.isLoading = true;
    this.messageService.sendMessage(this.to.trim(), this.body.trim()).subscribe({
      next: () => {
        alert('Message sent!');
        this.clearForm(form);
        this.isLoading = false;
      },
      error: (err) => {
        console.error('Error sending message', err);
        alert('Failed to send message.');
        this.isLoading = false;
      }
    });
  }
}
