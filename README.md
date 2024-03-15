# PlaytiniSpinSizer

PlaytiniSpinSizer is an iOS game developed in Swift using UIKit. The game features a rotating circle at the center of the screen and two horizontal obstacles moving from right to left. 

## Features
- The game has a rotating circle at the center of the screen.
- The size of the circle can be increased or decreased by tapping on "+" and "-" buttons respectively.
- Two horizontal obstacles move from the right side of the screen to the left at random heights.
- When the rotating circle collides with an obstacle, the device vibrates.
- The number of collisions is tracked and displayed on the screen.
- After 5 collisions, an alert is shown, asking the user if they want to restart the game.

## Implementation
- The game interface is created using UIKit.
- The rotating animation of the circle is implemented using UIView.animate function.
- A Timer is used to constantly check for collisions between the circle and the obstacles.
- The obstacles' movement across the screen is done using UIViewPropertyAnimator.
- The size of the circle is restricted between a minimum and maximum value, which is managed through property observers.
- The extension of `UIDevice` is used to trigger vibration on collision.


## Functionality
🚀Launching

![Simulator Screen Recording - iPhone 15 Pro - 2024-03-15 at 09 32 34](https://github.com/SashkaToropov/PlaytiniSpinSizer/assets/101838036/c971bc4e-5004-452c-ac7c-539e9c99aa06)

⚽️GamePlay + Alert

![Simulator Screen Recording - iPhone 15 Pro - 2024-03-15 at 09 35 29](https://github.com/SashkaToropov/PlaytiniSpinSizer/assets/101838036/bf5d2b21-9144-4f3a-99fc-3a7b39f27fbd)

