#!/bin/bash
F=/var/www/html/resources/views/livewire/layout-popups.blade.php
# NOTE: this code lives inside a double-quoted HTML x-data="..." attribute,
# so the value MUST use single quotes or the tag breaks and JS renders as page text.
docker exec coolify sed -i "s|this\.popups\.realtime = \"disabled\";|this.popups.realtime = 'disabled';|" $F
docker exec coolify sed -i "s|this\.popups\.realtime = \" disabled;|this.popups.realtime = 'disabled';|" $F
docker exec coolify sed -i "s|this\.popups\.sponsorship = !this\.isDevelopment && this\.shouldShowMonthlyPopup('popupSponsorship');|this.popups.sponsorship = false;|" $F
docker exec coolify sed -n '14,16p' $F
