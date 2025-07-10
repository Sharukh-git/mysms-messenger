import {
  Component,
  OnInit,
  AfterViewChecked,
  ViewChild,
  ElementRef
} from '@angular/core';
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
export class MessageListComponent implements OnInit, AfterViewChecked {
  messages: any[] = [];
  loading = false;
  errorMessage: string | null = null;

  @ViewChild('scrollContainer') private scrollContainer!: ElementRef;

  constructor(private messageService: MessageService) {}

  ngOnInit(): void {
    this.fetchMessages();
  }

  ngAfterViewChecked(): void {
    this.scrollToBottom();
  }

  fetchMessages(): void {
    this.loading = true;
    this.errorMessage = null;

    this.messageService.getMessages().subscribe({
      next: (data: any[]) => {
        this.messages = data;
        this.loading = false;
        this.scrollToBottom();
      },
      error: (err) => {
        console.error('Error fetching messages:', err);
        this.errorMessage = 'Failed to load messages. Please try again later.';
        this.loading = false;
      }
    });
  }

  scrollToBottom(): void {
    if (!this.scrollContainer) return;
    try {
      const el = this.scrollContainer.nativeElement;
      el.scrollTop = el.scrollHeight;
    } catch (err) {
      console.error('Scroll error:', err);
    }
  }

  formatPhone(phone: string): string {
  const digits = phone.replace(/\D/g, '');

  if (digits.length === 11 && digits.startsWith('1')) {
    
    return `${digits.slice(1, 4)}-${digits.slice(4, 7)}-${digits.slice(7)}`;
  } else if (digits.length === 10) {
    
    return `${digits.slice(0, 3)}-${digits.slice(3, 6)}-${digits.slice(6)}`;
  } else {
    
    return phone;
  }
 }

}
