'use strict';

const restaurant = {
	name: 'Classico Italiano',
	location: 'Via Angelo Tavanti 23, Firenze, Italy',
	categories: ['Italian', 'Pizzeria', 'Vegetarian', 'Organic'],
	starterMenu: ['Focaccia', 'Bruschetta', 'Garlic Bread', 'Caprese Salad'],
	mainMenu: ['Pizza', 'Pasta', 'Risotto'],

	order: function (starterIndex, mainIndex) {
		return [this.starterMenu[starterIndex], this.mainMenu[mainIndex]]
	},

	openingHours: {
		thu: {
			open: 12,
			close: 22,
		},
		fri: {
			open: 11,
			close: 23,
		},
		sat: {
			open: 0, // Open 24 hours
			close: 24,
		},
	},

	orderPasta: function (ingredient1, ingredient2, ingredient3) {
		console.log(`Pasta ingredients :${ingredient1} ${ingredient2} ${ingredient3}`)
	},

	orederPiza: function (mainIngredient, ...otherIngredients) {
		console.log(mainIngredient);
		console.log(otherIngredients)
	}
};

let a, b, others;
const arr = [a, b, ...others] = [1, 2, 3, 4, 5]

console.log(a, b, others)

const [pizza, risotto, ...otherFood] = [...restaurant.mainMenu, ...restaurant.starterMenu,]
console.log(pizza, risotto, otherFood)

const { sat, ...weekdays } = restaurant.openingHours
console.log(weekdays)


const add = function (...numbers) {
	let sum = 0
	numbers.forEach(element => {
		sum += element
	});
	console.log(sum)
	return sum
}


add(2, 3)
add(5, 3, 7, 2)
add(8, 2, 5, 3, 2, 1, 4)
const x = [23, 5, 7]
add(...x)

restaurant.orederPiza('mushrooms', 'onion', 'olives', 'spinach')

restaurant.orederPiza && restaurant.orederPiza('mushrooms', 'onion')
restaurant.orederPiz && restaurant.orederPiza('mushrooms', 'onion') // will not print anything


restaurant.numGuests = 0;
// const guests = restaurant.numGuests ? ? 10;
// console.log(guests)

const game = {
	team1: 'Bayern Munich',
	team2: 'Borrussia Dortmund',
	players: [
		[
			'Neuer',
			'Pavard',
			'Martinez',
			'Alaba',
			'Davies',
			'Kimmich',
			'Goretzka',
			'Coman',
			'Muller',
			'Gnarby',
			'Lewandowski',
		],
		[
			'Burki',
			'Schulz',
			'Hummels',
			'Akanji',
			'Hakimi',
			'Weigl',
			'Witsel',
			'Hazard',
			'Brandt',
			'Sancho',
			'Gotze',
		],
	],
	score: '4:0',
	scored: ['Lewandowski', 'Gnarby', 'Lewandowski', 'Hummels'],
	date: 'Nov 9th, 2037',
	odds: {
		team1: 1.33,
		x: 3.25,
		team2: 6.5,
	},
};

const [players1, players2] = game.players

const [goalkeeper, ...fieldPlayers] = players1
console.log(goalkeeper, fieldPlayers)

const allPlayers = [...players1, ...players2]
console.log(...allPlayers)

const playersFinal = [...players1, 'Thiago', 'Coutinho', 'Peristic']
console.log(playersFinal)

const { odds: { team1, x: draw, team2 } } = game
console.log(team1, draw, team2)

const printGoals = function (...players) {
	players.forEach(function (value, i) {
		console.log(`Player ${value} made ${i + 1} shoots.`)
	});
}
printGoals('Belanov', 'Blohin')

const winner = (team1 <= team2 && 'team1') || 'team2'
console.log(winner)

const menu = [...restaurant.starterMenu, ...restaurant.mainMenu]

for (const item of menu) {
	console.log(item)
}


for (const [ind, val] of menu.entries()) {
	console.log(ind, val)
}

console.log(restaurant.openingHours.mon?.open);

const days = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']

for (const day of days) {
	const open = restaurant.openingHours[day]?.open ?? null;
	console.log(`On day : ${day} ,we are ${open === null ? 'closed' : `open at ${open}.`}`)
}

console.log(restaurant.order?.(0, 1) ?? 'Method does not exist')

const users = []
console.log(users[0]?.name ?? 'User array empty')

for (const day of Object.keys(restaurant.openingHours)) {
	console.log(day)
}

for (const working_plan of Object.values(restaurant.openingHours)) {
	console.log(working_plan)
}

const entries = Object.entries(restaurant.openingHours)
console.log(entries)

for (const [key, { open, close }] of entries) {
	console.log(`On ${key} we open at ${open} and close at ${close}`)
}

// 1
for (const [goal, name] of game.scored.entries()) {
	console.log(`Goal ${goal + 1}: ${name}`)
}

//2 
console.log(Object.values(game.odds).reduce((previous, current) => {
	return previous + current
}, 0) / Object.keys(game.odds).length)

//3

for (const [key, value] of Object.entries(game.odds)) {
  let result = key == 'x'? 'draw' : 'victory'    
  let team = game?.[key] ?? ''
  console.log(`Odd of ${result} ${team}: ${value}`) 
}

//4 

const scorers = {}

for (const player of game.scored) {
	scorers[player] = scorers[player] + 1 || 1
}

console.log(scorers);

setTimeout(() => { console.log('End') }, 1000);