// ==UserScript==
// @name         New Userscript
// @namespace    http://tampermonkey.net/
// @version      2024-04-12
// @description  try to take over the world!
// @author       You
// @match        https://www.amazon.ca/*
// @grant        none
// @run-at       document-idle
// ==/UserScript==

(function() {
    const TAX = 0.15;

    // Todo: decide if it should just round up to the nearest dollar
    // Todo: fix queryselectorall only finding one element at a time

    const changeNode = function(node) {
        var wholeNode = node.querySelector('.a-price-whole');
        var fractionNode = node.querySelector('.a-price-fraction');
        var whole = wholeNode ? wholeNode.textContent : '0';
        var fraction = fractionNode ? fractionNode.textContent : '0';
        whole = parseInt(whole);
        fraction = parseInt(fraction);
        whole += whole * TAX;
        fraction += fraction * TAX;
        whole = Math.floor(whole);
        fraction = Math.floor(fraction);
        if (fraction >= 100) {
            whole += 1;
            fraction -= 100;
        }
        if (fraction < 10) {
            fraction = '0' + fraction;
        }
        wholeNode.textContent = whole;
        fractionNode.textContent = fraction;
    }

    const find = function() {
        console.log("Finding price nodes");
        document.querySelectorAll('.a-price').forEach((node) => {
            if (node.attributes['found']) {
                return;
            }
            node.attributes['found'] = true;
            console.log(node);
            console.log("Price node found")
            changeNode(node);
        });
    }
    //find();
    setInterval(find, 1000);
})();