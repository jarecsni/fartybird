# Farty Bird - App Store Roadmap

**Goal**: Ship a polished game with ads and IAP to the App Store

**Estimated Timeline**: 2-3 weeks

---

## Phase 1: Visual Polish (Week 1)
**Goal: Make it look like a real game**

### Character Sprites
- [ ] Create/source idle animation sprites
- [ ] Create/source fart animation sprites
- [ ] Create/source falling animation sprites
- [ ] Create/source death animation sprites
- [ ] Integrate character animations into game
- [ ] Test animations on device

### Pipe Graphics
- [ ] Design 3D-effect pipe texture with shading
- [ ] Add oil drips/grime details
- [ ] Create pipe cap graphics (fixed size, detailed)
- [ ] Implement 9-slice or body+cap rendering
- [ ] Remove hairline artifacts in gaps
- [ ] Test pipes at various screen sizes

### Background & Environment
- [ ] Create sky background (gradient or texture)
- [ ] Add parallax scrolling clouds
- [ ] Design ground texture (grass/dirt/concrete)
- [ ] Add background elements (trees/buildings - optional)
- [ ] Implement parallax scrolling system
- [ ] Test performance with layered backgrounds

### UI Polish
- [ ] Choose/implement better fonts
- [ ] Style score display
- [ ] Design game over screen
- [ ] Style menu buttons
- [ ] Add high score display
- [ ] Create settings screen (mute toggle)

### Particle Effects
- [ ] Enhance fart particles (already have basic)
- [ ] Create death explosion/feathers effect
- [ ] Add score popup sparkles/animation
- [ ] Test particle performance

---

## Phase 2: Audio (2-3 days)
**Goal: Bring it to life with sound**

### Sound Effects
- [ ] Source/create fart sound effect
- [ ] Source/create death sound
- [ ] Source/create score ping sound
- [ ] Source/create menu button click sounds
- [ ] Integrate AudioManager with all sounds
- [ ] Test audio on device (volume levels)

### Music (Optional)
- [ ] Source/create background music loop
- [ ] Implement music playback
- [ ] Add mute toggle functionality
- [ ] Test music doesn't interfere with other apps

---

## Phase 3: Core Polish & Bug Fixes (2-3 days)
**Goal: Smooth gameplay experience**

### Bug Fixes
- [ ] Fix pipe gap visual artifacts (if still present)
- [ ] Fine-tune collision detection
- [ ] Adjust character physics (feel right?)
- [ ] Fix any edge cases discovered during testing

### Game Feel
- [ ] Add screen shake on death
- [ ] Smooth transitions between game states
- [ ] Improve game over flow/timing
- [ ] Add juice to score increments
- [ ] Polish menu transitions

---

## Phase 4: Monetization (3-5 days)
**Goal: Ads + IAP working and tested**

### AdMob Integration
- [ ] Create AdMob account
- [ ] Add AdMob SDK to project
- [ ] Implement banner ads (menu screen)
- [ ] Implement interstitial ads (after game over)
- [ ] Implement rewarded video ads (optional - continue?)
- [ ] Test ads in development mode
- [ ] Configure ad frequency/timing

### In-App Purchase
- [ ] Set up App Store Connect IAP
- [ ] Create "Farty Bird Unlimited" product
- [ ] Integrate StoreKit
- [ ] Implement purchase flow UI
- [ ] Implement restore purchases
- [ ] Test with sandbox account
- [ ] Verify purchase persists across launches

### Ad-Free Experience
- [ ] Check purchase status on app launch
- [ ] Hide ads when purchased
- [ ] Show "Remove Ads" button prominently
- [ ] Test ad-free flow end-to-end

---

## Phase 5: App Store Requirements (2-3 days)
**Goal: Meet Apple's guidelines and prepare assets**

### Privacy & Legal
- [ ] Write privacy policy (required for ads)
- [ ] Write terms of service
- [ ] Implement GDPR consent for EU users
- [ ] Review age rating requirements
- [ ] Host privacy policy online

### App Store Assets
- [ ] Design app icon (1024x1024)
- [ ] Create screenshots for all required sizes
  - [ ] 6.7" display (iPhone 15 Pro Max)
  - [ ] 6.5" display (iPhone 11 Pro Max)
  - [ ] 5.5" display (iPhone 8 Plus)
- [ ] Create app preview video (optional)
- [ ] Write app description
- [ ] Write app subtitle
- [ ] Prepare "What's New" text

### Metadata
- [ ] Choose app name (check availability)
- [ ] Research and select keywords
- [ ] Choose primary category
- [ ] Choose secondary category (optional)
- [ ] Complete age rating questionnaire
- [ ] Set pricing (free with IAP)

---

## Phase 6: Testing & QA (3-5 days)
**Goal: Ship-ready, no crashes**

### Device Testing
- [ ] Test on iPhone SE (small screen)
- [ ] Test on iPhone 15 Pro (current gen)
- [ ] Test on iPhone 11 (older but common)
- [ ] Test on iOS 17
- [ ] Test on iOS 16 (if supporting)
- [ ] Decide: iPad support or iPhone-only?

### Edge Cases
- [ ] Test low battery mode
- [ ] Test interruptions (calls, notifications)
- [ ] Test background/foreground transitions
- [ ] Test memory warnings
- [ ] Test airplane mode
- [ ] Test with no internet (ads fail gracefully?)

### TestFlight Beta
- [ ] Upload build to TestFlight
- [ ] Invite 5-10 beta testers
- [ ] Collect feedback
- [ ] Fix critical issues
- [ ] Upload final build

---

## Phase 7: Final Polish (2-3 days)
**Goal: Last touches before submission**

### Performance
- [ ] Profile frame rate on older devices
- [ ] Optimize asset sizes if needed
- [ ] Reduce app bundle size
- [ ] Test cold launch time

### Onboarding
- [ ] Add tutorial or "tap to flap" hint
- [ ] Improve first-time user experience
- [ ] Test with someone who's never played

### Analytics (Optional)
- [ ] Integrate analytics SDK (Firebase?)
- [ ] Track session starts
- [ ] Track deaths/scores
- [ ] Track IAP conversion
- [ ] Set up analytics dashboard

---

## Ready for Submission!
- [ ] Final build uploaded to App Store Connect
- [ ] All metadata complete
- [ ] Screenshots uploaded
- [ ] Privacy policy live
- [ ] Submit for review

---

## Notes
- Each phase can overlap slightly
- Don't get stuck on perfection - ship and iterate
- TestFlight feedback is gold - listen to it
- Keep the core gameplay fun above all else

**Next Step**: Start with character sprites - make that chicken look good!
