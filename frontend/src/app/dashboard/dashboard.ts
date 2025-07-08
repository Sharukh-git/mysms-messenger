import { Component } from '@angular/core';
import { MessageFormComponent } from '../components/message-form/message-form';
import { MessageListComponent } from '../components/message-list/message-list';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [MessageFormComponent, MessageListComponent],
  templateUrl: './dashboard.html',
  styleUrls: ['./dashboard.scss']
})
export class DashboardComponent {}
