import { Component, EventEmitter, Output, inject, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MenuItem } from 'primeng/api';
import { UserSyncService } from '../../../../services/user-sync.service';

@Component({
  selector: 'app-sidebar',
  standalone: false,
  templateUrl: './sidebar.component.html',
  styleUrl: './sidebar.component.scss',
})
export class SidebarComponent implements OnInit {
  @Output() sidebarToggled = new EventEmitter<boolean>();

  isToggled = false;

  toggleSidebar() {
    this.isToggled = !this.isToggled;
    this.sidebarToggled.emit(this.isToggled);
  }

  items!: MenuItem[];

  private readonly router = inject(Router);

  constructor(private readonly userSyncService: UserSyncService) {}

  ngOnInit() {
    this.loadItems();

    // Restore sidebar state from localStorage
    const savedState = localStorage.getItem('sidebarCollapsed');
    if (savedState !== null) {
      this.isToggled = savedState === 'true';
      // Emit the initial state to sync with parent
      setTimeout(() => {
        this.sidebarToggled.emit(this.isToggled);
      }, 0);
    }
  }

  async loadItems(): Promise<void> {
    try {
      const userPermissions: string[] =
        (await this.userSyncService.getUserPermissions()) || [];

      this.items = [
        ...this.getATSItems(userPermissions),
        ...this.getUserManagementItems(userPermissions),
      ];
    } catch (error) {
      console.error('❌ Error loading sidebar items:', error);
    }
  }

  private getUserManagementItems(userPermissions: string[]): any[] {
    if (!userPermissions.includes('view_users')) return [];

    return [
      {
        label: 'User Management',
        expanded: true,
        items: [
          {
            label: 'Auth Registration',
            icon: 'pi pi-user-plus',
            route: '/dashboard/user-management',
          },
        ],
      },
    ];
  }
  private getATSItems(userPermissions: string[]): any[] {
    const hasEsignPermission = userPermissions.includes('ats_applications');
  const hasViewPermission = userPermissions.includes('view_applications');

  // If user has neither permission, return an empty array
  if (!hasEsignPermission && !hasViewPermission) return [];

  const items: any[] = [];

  if (hasViewPermission) {
    items.push({
      label: 'List Of Application',
      icon: 'pi pi-th-large',
      route: '/dashboard/application-list',
    });
  }

  if (hasEsignPermission) {
    items.push({
      label: 'List Of Application for Signature',
      icon: 'pi pi-pen-to-square',
      route: '/dashboard/application-list-esign',
    });
  }

  return [
    {
      label: 'FVCI Application',
      expanded: true,
      items,
    },
  ];
  }

  navigateTo(route: string) {
    this.router.navigate([route]);
  }

  visible: boolean = true;
}
