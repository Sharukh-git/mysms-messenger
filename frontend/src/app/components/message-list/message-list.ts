import { Component, OnInit } from '@angular/core';
import { CommonModule, DatePipe } from '@angular/common';
import { MessageService } from '../../services/message.service';

@Component({
  selector: 'app-message-list',
  standalone: true,
  imports: [CommonModule],
  providers: [DatePipe],
  templateUrl: './message-list.html',
  styleUrls: ['./message-list.scss']
})
export class MessageListComponent implements OnInit {
  messages: any[] = [];
  loading = false;

  constructor(private messageService: MessageService) {}

  ngOnInit() {
    this.fetchMessages();
  }

  fetchMessages() {
    this.loading = true;
    this.messageService.getMessages().subscribe({
      next: (data: any) => {
        this.messages = data;
        this.loading = false;
      },
      error: (err) => {
        console.error('Error fetching messages', err);
        this.loading = false;
      }
    });
  }
}
