// ==UserScript==
// @name         Voltorb Flip Spinners
// @namespace    http://tampermonkey.net/
// @version      0.0.1
// @description  Adds spinners to the inputs of numbers
// @author       Isaac Shoebottom
// @match        http://voltorbflip.com/
// @icon         http://voltorbflip.com/favicon.ico
// @grant        none
// @run-at       document-idle
// ==/UserScript==

// To add spinners I just need to change the input type from text to numbers

/**
 * Finds the board element
 * @returns {HTMLElement}
 */
function findBoard() {
		return document.getElementById("board");
}

/**
 * Finds all inputs that are children of the passed element
 * @param {HTMLElement} element
 * @returns {Array<HTMLElement>}
 */
function findInputs(element) {
	// Find all input elements that are children of the root element
	// Should have the type="text" attribute
	let col = element.getElementsByTagName("input");
	// Convert the HTMLCollection to an array
	return Array.from(col).filter((input) => input.type === "text");
}

/**
 * Adds a spinner to the input element on mouseover
 * @param {HTMLElement} inputElement
 * @returns {void}
 */
function addMouseOverSpinner(inputElement) {
	console.log("Adding mouseover spinner on element: " + inputElement);
	inputElement.addEventListener("mouseover", () => {
		console.log("Mouseover on element: " + inputElement);
		inputElement.type = "number";
	});
	inputElement.addEventListener("mouseout", () => {
		console.log("Mouseout on element: " + inputElement);
		inputElement.type = "text";
	});
}

/**
 * Executes the script
 * @returns {void}
 */
function execute() {
	let board = findBoard();
	if (!board) {
		console.log("Could not find board");
		return;
	}

	let inputs = findInputs(board);
	console.log("Found " + inputs.length + " inputs");

	inputs.forEach(addMouseOverSpinner)
}

execute();
