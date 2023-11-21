// ==UserScript==
// @name         PlexMusicFixer
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Swaps the order of the artist and album in the Plex Music player to match the order in the library view
// @author       Isaac Shoebottom
// @match        https://app.plex.tv/desktop/
// @icon         https://www.google.com/s2/favicons?sz=64&domain=plex.tv
// @grant        none
// ==/UserScript==

"use strict"

let musicLibraryNames: string[] = [
	"Music",
]
// How often should scripts run, in milliseconds
let interval = 1e2
// Keep track of all intervals
let intervalIds: number[] = []
let decidedIntervalIds: number[] = []

/**
 * Checks if the current page is a music page
 */
function isMusicPage(): boolean {
	// Find the current library name
	// Library title has the class selector "PageHeaderTitle-title"
	let nodes = document.querySelectorAll("[class*=\"PageHeaderTitle-title\"]")

	if (nodes.length === 0) {
		log("No library name found")
		return false
	}

	let libraryName = nodes.item(0).innerHTML
	return musicLibraryNames.includes(libraryName)
}

/**
 * Decides what page we're on, and runs the appropriate function
 */
function decidePage(): void {
	// Clear all intervals
	for (let id of intervalIds) {
		clearInterval(id)
	}

	// Always check, so these need to be extra safe
	let id = setInterval(alwaysCheck, interval)
	intervalIds.push(id)

	if (!isMusicPage()) {
		log("Not music page")
		return
	}

	let url = window.location.href
	if (url.includes("com.plexapp.plugins.library")) {
		log("Library page")
		let id = setInterval(libraryPage, interval)
		intervalIds.push(id)
	} else if (url.includes("details?key=%2Flibrary%2Fmetadata")) {
		log("Details page")
		let id = setInterval(albumPage, interval)
		intervalIds.push(id)
	}


	for (let id of decidedIntervalIds) {
		clearInterval(id)
	}
}

/**
 * Swaps the artist and album in each card
 */
function swapCards(cards): void {
	// For each card, get all html elements, and swap the second and third elements
	for (let card of cards) {
		// Check if the card has already been swapped
		if (card.attributes.swap) {
			continue
		}

		let elements = card.children
		let artist = elements.item(1)
		let album = elements.item(2)
		card.insertBefore(album, artist)

		log("Swapped artist: " + artist.innerText + " and album: " + album.innerText)

		// Album has isSecondary
		let secondaryClass = album.className.split(" ").find((className) => className.includes("isSecondary"))

		// Remove isSecondary from album
		album.classList.remove(secondaryClass)

		// Add isSecondary to artist
		artist.classList.add(secondaryClass)

		// Add a swap property to the card, so we can check if it's already been swapped
		card.attributes.swap = true
	}
}

/**
 * Logic for library pages
 */
function libraryPage() {
	// Select all divs with the attribute data-testid="cellItem"
	let cards = document.querySelectorAll("[data-testid=\"cellItem\"]")
	if (cards.length === 0) {
		log("No cards found")
		return
	}
	swapCards(cards)
}

/**
 * Logic for album pages
 */
function albumPage() {
	let metadata = document.querySelectorAll("[data-testid=\"metadata-top-level-items\"]")
	// Two divs down from metadata is the container for the artist and album
	let container: any = metadata.item(0).children.item(0).children.item(0)
	if (container.attributes.swap) {
		return
	}

	// Check if the container has two children, so there isn't null errors
	if (container.children.length < 2) {
		log("Not on album page")
		return
	}
	let artist = container.children.item(0)
	let album = container.children.item(1)
	// Check if the artist and album are what we're looking for, so we don't swap the wrong elements
	if (
		artist.attributes.getNamedItem("data-testid").value !== "metadata-title" ||
		album.attributes.getNamedItem("data-testid").value !== "metadata-subtitle"
	) {
		log("Not on album page")
		return
	}

	container.insertBefore(album, artist)
	log("Swapped artist: " + artist.innerText + " and album: " + album.innerText)

	let newArtist = document.createElement("h2")
	let newAlbum = document.createElement("h1")
	newArtist.innerHTML = artist.innerHTML
	newAlbum.innerHTML = album.innerHTML

	// Copy all attributes from album to newArtist
	for (let attr of album.attributes) {
		newArtist.setAttribute(attr.name, attr.value)
	}
	// Copy all attributes from artist to newAlbum
	for (let attr of artist.attributes) {
		newAlbum.setAttribute(attr.name, attr.value)
	}

	artist.replaceWith(newArtist)
	album.replaceWith(newAlbum)

	// Add a swap property to the container, so we can check if it's already been swapped
	container.attributes.swap = true
}

function alwaysCheck() {
	soundtrackCheck()
	playerCheck()
}

/**
 * Checks if the current page is a soundtrack element, and swaps the artist and album if it is
 */
function soundtrackCheck() {
	// Select for elements with the title="Soundtracks" attribute
	let soundtracks = document.querySelectorAll("[title=\"Soundtracks\"]")
	if (soundtracks.length !== 0) {
		// Get holder of soundtrack cards
		let root = soundtracks.item(0).parentElement.parentElement.parentElement
		let cardHolder = root.lastElementChild.lastElementChild.lastElementChild
		swapCards(cardHolder.children)
	}
}

/**
 * Checks for a few elements that could be present, and swaps the artist and album if they are
 */
function playerCheck() {
	// Mini player
	let player = document.querySelectorAll("[class*=\"PlayerControlsMetadata-container\"]")
	if (player.length !== 0) {
		let playerMetadata = player.item(0)
		let holder = playerMetadata.children.item(1)
		swapPlayer(holder)
	}
	// Big player
	let bigPlayer = document.querySelectorAll("[class*=\"AudioVideoFullMusic-titlesContainer\"]")
	if (bigPlayer.length !== 0) {
		let playerMetadata = bigPlayer.item(0)
		let holder = playerMetadata.children.item(1)
		swapPlayer(holder)
	}
}

/**
 * Swaps the artist and album in the player
 */
function swapPlayer(holder) {
	if (holder.attributes.swap) {
		return
	}
	let artist = holder.children.item(0)
	let dash = holder.children.item(1)
	let album = holder.children.item(2)
	// Swap artist and album
	// Remove all children
	holder.removeChild(artist)
	holder.removeChild(dash)
	holder.removeChild(album)
	// Add back in the correct order
	holder.appendChild(album)
	holder.appendChild(dash)
	holder.appendChild(artist)
	holder.attributes.swap = true
}

function logSwap(artist, album) {
	log("Swapped artist: " + artist + " and album: " + album)
}

function log(message: string): void {
	console.log("PlexMusicFixer: " + message)
}

// "Main"
// On href change, run decidePage
let href = ""
const observer = new MutationObserver(() => {
	if (window.location.href !== href) {
		href = window.location.href
		log("Deciding page")
		decidedIntervalIds.push(setInterval(decidePage, interval))
	}
})
observer.observe(document, { childList: true, subtree: true })