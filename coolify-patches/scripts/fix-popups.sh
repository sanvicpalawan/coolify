#!/bin/bash
F=/var/www/html/resources/views/livewire/layout-popups.blade.php
docker exec coolify sed -i 's|this\.popups\.realtime = " disabled;|this.popups.realtime = "disabled";|' $F
docker exec coolify sed -i "s|this\.popups\.sponsorship = !this\.isDevelopment && this\.shouldShowMonthlyPopup('popupSponsorship');|this.popups.sponsorship = false;|" $F
docker exec coolify sed -n '14,16p' $F
