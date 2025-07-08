import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
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

  constructor(private messageService: MessageService) {}

  onSubmit() {
    const payload = { to: this.to, body: this.body };
    this.messageService.sendMessage(payload.to, payload.body).subscribe({
      next: () => {
        alert('Message sent!');
        this.to = '';
        this.body = '';
      },
      error: (err) => {
        console.error('Error sending message', err);
        alert('Failed to send message.');
      }
    });
  }
}
