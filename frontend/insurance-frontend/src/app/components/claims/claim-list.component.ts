import { Component, OnInit, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ClaimService } from '../../services/claim.service';
import { AuthService } from '../../services/auth.service';
import { Claim } from '../../models/claim.interface';

@Component({
  selector: 'app-claim-list',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './claim-list.component.html',
  styleUrls: ['./claim-list.component.css']
})
export class ClaimListComponent implements OnInit {
  private claimService = inject(ClaimService);
  private authService = inject(AuthService);
  
  protected readonly claims = signal<Claim[]>([]);
  protected readonly loading = signal(false);
  protected readonly errorMessage = signal('');

  ngOnInit(): void {
    this.loadClaims();
  }

  loadClaims(): void {
    this.loading.set(true);
    this.errorMessage.set('');
    
    const role = this.authService.role || JSON.parse(localStorage.getItem('user') || '{}').role;
    const username = this.authService.username || JSON.parse(localStorage.getItem('user') || '{}').username;
    
    if (!role) {
      console.error('No role found in storage');
      this.errorMessage.set('User session invalid. Please log in again.');
      this.loading.set(false);
      return;
    }

    const userData = JSON.parse(localStorage.getItem('user') || '{}');
    const userId = userData.userId || parseInt(username?.replace(/\D/g, '') || '0');
    
    const request = role === 'ADMIN' 
      ? this.claimService.getAllClaims() 
      : this.claimService.getClaimsByUser(userId);

    request.subscribe({
      next: (res: any) => {
        const claimsData = Array.isArray(res) ? res : (res?.data || []);
        this.claims.set(claimsData);
        this.loading.set(false);
      },
      error: (err: any) => {
        this.errorMessage.set('Failed to load claims. Please ensure the backend is running.');
        this.loading.set(false);
      }
    });
  }
}
