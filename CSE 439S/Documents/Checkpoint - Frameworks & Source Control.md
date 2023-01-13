# VENI VIDI Checkpoint 1: Frameworks and Source Control
## Source Control
* Main Branch will be used for hosting production code
* Each functionality (along with its testing code) will be in its own branch
* Functionality branch will be merged into main branch once the feature is ready for release

## Storyboard
* We will start the project with Storyboard, but plan to rely mainly on code
* For the simple UI, such as Sign-In and launch board, we can use storyboards 
* For our interface, we may consider using framing pods like IGListKit or DCFrame
	* IGListKit: https://github.com/Instagram/IGListKit
	* DCFrame: https://github.com/bytedance/DCFrame 

## Project Structure and Design Pattern
* With the benefits from using a framing pod like IGListKit, MVVM would be an ideal structure for our project. Using MVVM would allow us to split the views into smaller pieces that allow us to manage data and its interaction with UIs more efficiently.

## Frameworks and SDKs
* IGListKit and DCFrame: they would allow us to design and make our interface with greater efficiency
	* Backup solution: IGListKit and DCFrame are the backup solution to each other
* Core Data with CloudKit: they allow us to store and handle data in an easy and elegant way
	* Backup solution: we don’t have one. We believe in Apple. (We will use Firestore if necessary)