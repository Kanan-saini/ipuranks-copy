# IPU Ranks - Student Result System

A premium, Gen Z-style Flutter mobile app for displaying student academic results with a **dark theme, glassmorphism, smooth animations, and neon green accents**.

## 🎨 Design Highlights

### Theme & Colors
- **Dark Background**: `#0a0e27` (deep navy)
- **Primary Accent**: `#84cc16` (neon lime/green)
- **Secondary Accents**: 
  - Purple/Blue: `#6366f1`
  - Pink: `#ec4899`
- **Glassmorphism**: Blur effects, transparency, and subtle borders
- **Glow Effects**: Neon green shadows for premium feel

### UI Components
- Smooth rounded corners (16-20px radius) on all elements
- Glass-effect cards with border transparency
- Gradient backgrounds
- Animated button scales on tap
- Smooth page transitions (slide/fade)
- Staggered animation for table rows

---

## 📱 App Flow

### Screen 1: Enrollment Input
- Centered layout with "IPU Ranks" branding
- Enrollment number input field with soft glow
- "Next →" button with gradient and scale animation
- Helpful tip section about enrollment numbers

**Features:**
- Input validation
- Smooth fade-in animation on screen load
- Animated background elements

---

### Screen 2: Login Screen
- Displays prefilled enrollment number (from Screen 1)
- Password field with visibility toggle (👁️ icon)
- reCAPTCHA placeholder (with icon)
- Loading state with animated spinner during login
- Forgot password link

**Features:**
- Smooth slide transition from enrollment screen
- Password visibility toggle with custom icon color
- Loading animation (rotating circles)
- 2-second simulated authentication delay

---

### Screen 3: Result Dashboard (Main Screen)
Displays a **modal-style result card** with comprehensive student data.

#### Top Info Section
```
Name:          Abhishek
Marks:         906 / 1000
Percentage:    90.6%
Credit Marks:  2288 / 2500
SGPA:          9.84
```

#### Features
- **Animated Slide-Up**: Result card slides up from bottom
- **Info Cards**: Color-coded sections (neon green, purple, pink)
- **Dividers**: Separating each info pair
- **Toggleable Sections**:
  - Show Internal/External Marks
  - Show Paper IDs
  - Smooth animated switches

#### Subject Details Table
Displays all 6 subjects with:
- **Subject Name** with credits
- **Total Marks** (highlighted in neon green)
- **Grade** (color-coded: A+ = green, A = purple)
- **Highest Badge**: For the highest-scoring subject
- **Expandable Rows**: Shows internal/external marks and paper IDs when toggled
- **Staggered Animation**: Each row fades in with a slight upward slide

#### Interactive Elements
- **Logout Button**: Top-right corner
- **Smooth Scrolling**: Content area is scrollable
- **Animated Toggles**: Smooth switch with sliding indicator

---

## 🎬 Animations

### Page Transitions
- **Enrollment → Login**: Slide from right with smooth curve
- **Login → Results**: Fade transition
- **Result Card Appearance**: Slide up from bottom + fade in

### Component Animations
- **Buttons**: Scale down (0.95) on tap with 600ms duration
- **Toggles**: Smooth 300ms switch animation
- **Subject Rows**: Staggered fade-in (100ms offset per row)
- **Loading Spinner**: Rotating circles (outer clockwise, inner counter-clockwise)

---

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point & navigation
├── models/
│   └── result_model.dart             # StudentResult & Subject models + dummy data
├── screens/
│   ├── enrollment_screen.dart        # Screen 1: Enrollment input
│   ├── login_screen.dart             # Screen 2: Login
│   └── result_dashboard.dart         # Screen 3: Results display
└── widgets/
    ├── custom_button.dart            # Reusable animated button
    ├── input_field.dart              # Reusable input with glow effect
    ├── result_card.dart              # Main result display card
    └── subject_row.dart              # Subject detail row
```

---

## 🛠️ Key Components

### CustomButton
- Gradient background (neon green to lime)
- Glow shadow effect
- Scale animation on tap (0.95 → 1.0)
- Ripple effect on press
- Customizable colors and sizes

### InputField
- Rounded corners with soft glow on focus
- Visibility toggle for password fields
- Floating glow effect when focused
- Custom cursor color (neon green)

### ResultCard
- Slide-up animation on appearance
- Interactive toggles for data visibility
- Color-coded info sections
- Scrollable content area

### SubjectRow
- Staggered fade-in animation (per index)
- Highest mark badge in neon green
- Color-coded grade badges
- Expandable details (internal/external, paper ID)

---

## 💡 Premium Features

✅ **Glassmorphism**: Blur and transparency effects throughout
✅ **Neon Accents**: Neon green (#84cc16) glow on interactive elements
✅ **Smooth Animations**: 300-1000ms transitions for visual feedback
✅ **Dark Theme**: Premium dark background with subtle gradients
✅ **Loading States**: Animated spinner during authentication
✅ **Interactive Toggles**: Smooth animated switches
✅ **Staggered Effects**: Rows animate in sequence for visual appeal
✅ **Premium Polish**: Shadows, borders, and subtle elevation

---

## 🎯 Dummy Data

The app uses hardcoded dummy data for the student:

```dart
Name:        Abhishek
Enrollment:  12345678
Subjects:    6 subjects with marks, credits, and grades
Highest:     Data Structures (80 marks)
SGPA:        9.84
```

All data is static and doesn't require backend calls.

---

## 🚀 Running the App

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Build APK (Android)
flutter build apk

# Build for iOS
flutter build ios
```

---

## 📋 Navigation Flow

```
EnrollmentScreen
    ↓ (input enrollment no.)
LoginScreen
    ↓ (enter password)
ResultDashboard
    ↓ (logout button)
Back to EnrollmentScreen
```

---

## 🎨 Customization

### Colors
- Update color codes in widget files (`#84cc16` for neon green)
- Gradient definitions in screen files for background

### Animations
- Adjust duration in `AnimationController` constructors (milliseconds)
- Modify curves in `CurvedAnimation` for different easing effects

### Data
- Edit dummy data in `lib/models/result_model.dart`
- Update subject list in `dummyResult` object

---

## ✨ Code Quality

- **Clean Architecture**: Separation of screens, widgets, and models
- **Reusable Components**: CustomButton, InputField, etc.
- **Proper State Management**: StatefulWidget for animations and state
- **Animation Best Practices**: SingleTickerProviderStateMixin, TweenAnimationBuilder
- **Readable Code**: Clear variable names and structured layout

---

## 📝 Notes

- No backend/API integration (pure frontend showcase)
- All data is static and dummy
- Optimized for mobile (responsive UI)
- Works on iOS, Android, Web, macOS, Linux, and Windows
- Uses only Flutter standard libraries (no external packages)

---

**Built with ❤️ for premium mobile app design**
