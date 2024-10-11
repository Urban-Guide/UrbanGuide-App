// Add this above your TouristHome widget or in a separate file
class Place {
  final String number;
  final String title;
  final String mainImage;
  final String details;
  final String description;
  final String type;
  final String city;
  final String locationLink;
  final List<String> additionalImages;
  final List<String> galleryImages;

  Place({
    required this.number,
    required this.title,
    required this.mainImage,
    required this.details,
    required this.description,
    required this.type,
    required this.city,
    required this.locationLink,
    required this.additionalImages,
    required this.galleryImages,
  });
}

// List of places to display
final List<Place> places = [
  //Places from Galle, LK
  Place(
    number: 'F001',
    title: 'Jungle Beach',
    mainImage: 'assets/f11.jpg',
    details: 'A hidden beach retreat',
    description:
        'Jungle Beach is a secluded beach in Unawatuna, offering a peaceful and fun getaway with clear waters for snorkeling and sunbathing.',
    type: 'Fun',
    city: 'Galle, LK',
    locationLink: 'https://maps.app.goo.gl/AjMXhZAgBG6ruKP99',
    additionalImages: ['assets/f12.jpg', 'assets/f13.jpeg'],
    galleryImages: [
      'assets/f12.jpg',
      'assets/f13.jpeg',
      'assets/f14.jpg',
      'assets/f15.jpg',
      'assets/f16.jpg',
      'assets/f11.jpg'
    ],
  ),
  Place(
    number: 'F002',
    title: 'Unawatuna Beach',
    mainImage: 'assets/f21.jpeg',
    details: 'A popular tourist beach',
    description:
        'Unawatuna Beach is one of the most famous beaches in Sri Lanka, perfect for swimming, surfing, and a variety of fun water sports activities.',
    type: 'Fun',
    city: 'Galle, LK',
    locationLink: 'https://maps.app.goo.gl/88Qppb1r23mQMdRL8',
    additionalImages: ['assets/f22.jpg', 'assets/f23.jpeg'],
    galleryImages: [
      'assets/f22.jpg',
      'assets/f23.jpeg',
      'assets/f24.jpeg',
      'assets/f25.jpg',
      'assets/f26.webp',
      'assets/f21.jpeg'
    ],
  ),
  Place(
    number: 'H001',
    title: 'Galle Fort',
    mainImage: 'assets/h11.png',
    details: 'A UNESCO World Heritage site',
    description:
        'Galle Fort is a UNESCO World Heritage site built by the Portuguese and later fortified by the Dutch. It is a historical marvel with colonial architecture and rich history.',
    type: 'Historical',
    city: 'Galle, LK',
    locationLink: 'https://maps.app.goo.gl/hVe3XfzkqVaewqF8A',
    additionalImages: ['assets/h12.jpg', 'assets/h13.jpg'],
    galleryImages: [
      'assets/h12.jpg',
      'assets/h13.jpg',
      'assets/h14.jpg',
      'assets/h15.jpg',
      'assets/h16.jpg',
      'assets/h11.png'
    ],
  ),
  Place(
    number: 'N001',
    title: 'Hiyare Reservoir',
    mainImage: 'assets/n11.jpg',
    details: 'A tranquil nature reserve',
    description:
        'Hiyare Reservoir is a serene nature reserve offering rich biodiversity, scenic views, and opportunities for birdwatching and nature walks.',
    type: 'Nature',
    city: 'Galle, LK',
    locationLink: 'https://maps.app.goo.gl/zJiJeZoNRM5Jhq7C6',
    additionalImages: ['assets/n12.jpg', 'assets/n13.jpg'],
    galleryImages: [
      'assets/n12.jpg',
      'assets/n13.jpg',
      'assets/n14.jpg',
      'assets/n15.jpg',
      'assets/n16.jpg',
      'assets/n11.jpg'
    ],
  ),
  Place(
    number: 'N002',
    title: 'Kanneliya Forest Reserve',
    mainImage: 'assets/n21.jpeg',
    details: 'A tropical rainforest',
    description:
        'Kanneliya Forest Reserve is a tropical rainforest, home to a diverse range of flora and fauna. It offers scenic nature trails and waterfalls.',
    type: 'Nature',
    city: 'Galle, LK',
    locationLink: 'https://maps.app.goo.gl/191RSgvvyMdP3ea57',
    additionalImages: ['assets/n22.jpeg', 'assets/n23.jpg'],
    galleryImages: [
      'assets/n22.jpeg',
      'assets/n23.jpg',
      'assets/n24.jpg',
      'assets/n25.jpg',
      'assets/n26.jpg',
      'assets/n21.jpeg'
    ],
  ),
  Place(
    number: 'N003',
    title: 'Madu River Safari',
    mainImage: 'assets/n31.jpg',
    details: 'Mangrove ecosystem',
    description:
        'Madu River Safari lets you explore a pristine mangrove ecosystem. The area is rich in biodiversity, including rare birds and aquatic life.',
    type: 'Nature',
    city: 'Galle, LK',
    locationLink: 'https://maps.app.goo.gl/FtNwsxxXtqSNW2vZ7',
    additionalImages: ['assets/n32.jpeg', 'assets/n33.jpeg'],
    galleryImages: [
      'assets/n32.jpeg',
      'assets/n33.jpeg',
      'assets/n34.jpeg',
      'assets/n35.jpg',
      'assets/n36.jpg',
      'assets/n31.jpg'
    ],
  ),
  Place(
    number: 'N004',
    title: 'Rumassala Sanctuary',
    mainImage: 'assets/n41.webp',
    details: 'A coastal nature retreat',
    description:
        'Rumassala Sanctuary is a coastal nature retreat with stunning views of the Indian Ocean, diverse plant life, and excellent hiking trails.',
    type: 'Nature',
    city: 'Galle, LK',
    locationLink: 'https://maps.app.goo.gl/x2X1GpgZWvSFVBJd6',
    additionalImages: ['assets/n42.jpg', 'assets/n43.jpeg'],
    galleryImages: [
      'assets/n42.jpg',
      'assets/n43.jpeg',
      'assets/n44.jpg',
      'assets/n45.jpg',
      'assets/n46.jpg',
      'assets/n41.webp'
    ],
  ),
  Place(
    number: 'H002',
    title: 'Dutch Reformed Church',
    mainImage: 'assets/h21.jpeg',
    details: 'A colonial-era church',
    description:
        'The Dutch Reformed Church in Galle Fort is one of the oldest Protestant churches in Sri Lanka, built in the 17th century with fascinating architecture.',
    type: 'Historical',
    city: 'Galle, LK',
    locationLink: 'https://maps.app.goo.gl/ihGGEhWj9EPJ1tybA',
    additionalImages: ['assets/h22.jpeg', 'assets/h23.jpg'],
    galleryImages: [
      'assets/h22.jpeg',
      'assets/h23.jpg',
      'assets/h24.jpeg',
      'assets/h25.jpg',
      'assets/h26.jpg',
      'assets/h21.jpeg'
    ],
  ),
  Place(
    number: 'H003',
    title: 'National Maritime Museum',
    mainImage: 'assets/h31.jpg',
    details: 'A museum dedicated to maritime history',
    description:
        'The National Maritime Museum in Galle showcases Sri Lanka’s maritime history, featuring exhibits on marine archaeology, artifacts, and shipwrecks.',
    type: 'Historical',
    city: 'Galle, LK',
    locationLink: 'https://maps.app.goo.gl/pkZUSyXC8MqoUFAf8',
    additionalImages: ['assets/h32.jpg', 'assets/h33.jpeg'],
    galleryImages: [
      'assets/h32.jpg',
      'assets/h33.jpeg',
      'assets/h34.jpg',
      'assets/h35.jpg',
      'assets/h36.jpeg',
      'assets/h31.jpg'
    ],
  ),
  Place(
    number: 'H004',
    title: 'Martin Wickramasinghe Museum',
    mainImage: 'assets/h41.jpg',
    details: 'A museum of cultural heritage',
    description:
        'This museum celebrates the life and work of renowned Sri Lankan author Martin Wickramasinghe and explores traditional Sri Lankan culture and history.',
    type: 'Historical',
    city: 'Galle, LK',
    locationLink: 'https://maps.app.goo.gl/mL7T169TaSMJ26ty5',
    additionalImages: ['assets/h42.jpg', 'assets/h43.jpeg'],
    galleryImages: [
      'assets/h42.jpg',
      'assets/h43.jpeg',
      'assets/h44.jpeg',
      'assets/h45.jpg',
      'assets/h46.jpg',
      'assets/h41.jpg'
    ],
  ),
  Place(
    number: 'F003',
    title: 'Lagoon Canoeing Tour',
    mainImage: 'assets/f31.jpg',
    details: 'A fun-filled canoeing adventure',
    description:
        'Experience a fun-filled canoeing adventure through the calm lagoons of Galle, exploring its lush mangroves and vibrant wildlife.',
    type: 'Fun',
    city: 'Galle, LK',
    locationLink: 'https://maps.app.goo.gl/MPmaFhSDuMzGk1xy9',
    additionalImages: ['assets/f32.jpg', 'assets/f33.jpg'],
    galleryImages: [
      'assets/f32.jpg',
      'assets/f33.jpg',
      'assets/f34.jpg',
      'assets/f35.webp',
      'assets/f36.jpg',
      'assets/f31.jpg'
    ],
  ),
  Place(
    number: 'F004',
    title: 'Sea Turtle Hatchery',
    mainImage: 'assets/f41.jpg',
    details: 'A turtle conservation project',
    description:
        'Visit the Sea Turtle Hatchery for a fun and educational experience, where you can learn about turtle conservation and even release baby turtles into the sea.',
    type: 'Fun',
    city: 'Galle, LK',
    locationLink: 'https://maps.app.goo.gl/L4FovCBu7aH2UapP7',
    additionalImages: ['assets/f42.jpeg', 'assets/f43.jpeg'],
    galleryImages: [
      'assets/f42.jpeg',
      'assets/f43.jpeg',
      'assets/f44.jpg',
      'assets/f45.jpg',
      'assets/f46.jpeg',
      'assets/f41.jpg'
    ],
  ),

  //Places from Colombo, LK
  Place(
    number: 'F005',
    title: 'Galle Face Green',
    mainImage: 'assets/f51.jpg',
    details: 'A scenic urban park by the sea',
    description:
        'Galle Face Green is a popular destination for families and tourists to enjoy outdoor activities, street food, and sunset views by the Indian Ocean.',
    type: 'Fun',
    city: 'Colombo, LK',
    locationLink: 'https://maps.app.goo.gl/cwqLY6Tec34wBtDJ7',
    additionalImages: ['assets/f52.jpg', 'assets/f53.jpg'],
    galleryImages: [
      'assets/f52.jpg',
      'assets/f53.jpg',
      'assets/f54.jpg',
      'assets/f55.jpg',
      'assets/f56.jpeg',
      'assets/f51.jpg'
    ],
  ),
  Place(
    number: 'F006',
    title: 'Viharamahadevi Park',
    mainImage: 'assets/f61.jpg',
    details: 'A park with playground and lake',
    description:
        'Viharamahadevi Park is the largest park in Colombo, offering lush greenery, walking paths, and fun activities for families, including a children’s playground.',
    type: 'Fun',
    city: 'Colombo, LK',
    locationLink: 'https://maps.app.goo.gl/NmBz5ntwWSMGDYa89',
    additionalImages: ['assets/f62.png', 'assets/f63.jpg'],
    galleryImages: [
      'assets/f62.png',
      'assets/f63.jpg',
      'assets/f64.jpg',
      'assets/f65.jpg',
      'assets/f66.png',
      'assets/f61.jpg'
    ],
  ),
  Place(
    number: 'H005',
    title: 'Colombo National Museum',
    mainImage: 'assets/h51.jpeg',
    details: 'Sri Lanka’s largest museum',
    description:
        'The Colombo National Museum houses a vast collection of Sri Lankan artifacts, art, and historical exhibits, tracing the country’s rich cultural heritage.',
    type: 'Historical',
    city: 'Colombo, LK',
    locationLink: 'https://maps.app.goo.gl/BAoo5Z27baUhKrwRA',
    additionalImages: ['assets/h52.jpg', 'assets/h53.jpg'],
    galleryImages: [
      'assets/h52.jpg',
      'assets/h53.jpg',
      'assets/h54.jpg',
      'assets/h55.jpeg',
      'assets/h56.jpg',
      'assets/h51.jpeg'
    ],
  ),
  Place(
    number: 'H006',
    title: 'Independence Memorial Hall',
    mainImage: 'assets/h61.jpg',
    details: 'A monument commemorating Sri Lanka’s independence',
    description:
        'Independence Memorial Hall is a national monument in Colombo, built to commemorate Sri Lanka’s independence from British rule in 1948. It’s a popular landmark and a venue for national celebrations.',
    type: 'Historical',
    city: 'Colombo, LK',
    locationLink: 'https://maps.app.goo.gl/yLyNEk775VkvekRX8',
    additionalImages: ['assets/h62.jpg', 'assets/h63.jpg'],
    galleryImages: [
      'assets/h62.jpg',
      'assets/h63.jpg',
      'assets/h64.jpg',
      'assets/h65.jpg',
      'assets/h66.jpeg',
      'assets/h61.jpg'
    ],
  ),
  Place(
    number: 'N005',
    title: 'Diyatha Uyana',
    mainImage: 'assets/n51.jpg',
    details: 'A modern urban park by the lake',
    description:
        'Diyatha Uyana is an urban park in Colombo by the Diyawanna Lake, featuring walking paths, a floating restaurant, and botanical gardens, making it an ideal spot for relaxation and nature walks.',
    type: 'Nature',
    city: 'Colombo, LK',
    locationLink: 'https://maps.app.goo.gl/hhR8fozH3uCNwkYi9',
    additionalImages: ['assets/n52.jpg', 'assets/n53.jpg'],
    galleryImages: [
      'assets/n52.jpg',
      'assets/n53.jpg',
      'assets/n54.jpg',
      'assets/n55.jpeg',
      'assets/n56.jpg',
      'assets/n51.jpg'
    ],
  ),
  Place(
    number: 'N006',
    title: 'Beddagana Wetland Park',
    mainImage: 'assets/n61.jpg',
    details: 'A protected wetland ecosystem',
    description:
        'Beddagana Wetland Park is a protected area in Colombo, rich in biodiversity and birdlife, offering scenic boardwalks, nature trails, and observation decks.',
    type: 'Nature',
    city: 'Colombo, LK',
    locationLink: 'https://maps.app.goo.gl/Q6VnUiM3bKYQe1ea6',
    additionalImages: ['assets/n62.jpeg', 'assets/n63.jpg'],
    galleryImages: [
      'assets/n62.jpeg',
      'assets/n63.jpg',
      'assets/n64.png',
      'assets/n65.png',
      'assets/n66.jpeg',
      'assets/n61.jpg'
    ],
  ),
  Place(
    number: 'F007',
    title: 'Colombo Lotus Tower',
    mainImage: 'assets/f71.jpeg',
    details: 'The tallest structure in South Asia',
    description:
        'Colombo Lotus Tower is an iconic skyscraper offering panoramic views of the city and beyond. It also houses restaurants, observation decks, and entertainment zones.',
    type: 'Fun',
    city: 'Colombo, LK',
    locationLink: 'https://maps.app.goo.gl/K9qTyASavgmHzoWN9',
    additionalImages: ['assets/f72.jpg', 'assets/f73.jpeg'],
    galleryImages: [
      'assets/f72.jpg',
      'assets/f73.jpeg',
      'assets/f74.jpg',
      'assets/f75.jpg',
      'assets/f76.png',
      'assets/f71.jpeg'
    ],
  ),
  Place(
    number: 'F008',
    title: 'Colombo City Centre Mall',
    mainImage: 'assets/f81.jpg',
    details: 'A modern shopping and entertainment hub',
    description:
        'Colombo City Centre Mall is a premier shopping destination offering international brands, dining options, and entertainment such as cinemas and arcades.',
    type: 'Fun',
    city: 'Colombo, LK',
    locationLink: 'https://maps.app.goo.gl/osHCPzQkyv8b6igA8',
    additionalImages: ['assets/f82.jpg', 'assets/f83.jpeg'],
    galleryImages: [
      'assets/f82.jpg',
      'assets/f83.jpeg',
      'assets/f84.jpeg',
      'assets/f85.jpg',
      'assets/f86.png',
      'assets/f81.jpg'
    ],
  ),
  Place(
    number: 'H007',
    title: 'Old Parliament Building',
    mainImage: 'assets/h71.jpg',
    details: 'A historical building with colonial architecture',
    description:
        'The Old Parliament Building in Colombo is an important historical site, featuring colonial architecture and serving as the seat of the Parliament of Sri Lanka until 1983.',
    type: 'Historical',
    city: 'Colombo, LK',
    locationLink: 'https://maps.app.goo.gl/K7ZVtrwHuTXxA85F6',
    additionalImages: ['assets/h72.jpg', 'assets/h73.jpg'],
    galleryImages: [
      'assets/h72.jpg',
      'assets/h73.jpg',
      'assets/h74.jpg',
      'assets/h75.jpg',
      'assets/h76.jpg',
      'assets/h71.jpg'
    ],
  ),
  Place(
    number: 'H008',
    title: 'Wolvendaal Church',
    mainImage: 'assets/h81.jpg',
    details: 'A Dutch-era Protestant church',
    description:
        'Wolvendaal Church is one of the oldest Protestant churches in Sri Lanka, built during the Dutch colonial period in the 18th century, showcasing beautiful Dutch architecture.',
    type: 'Historical',
    city: 'Colombo, LK',
    locationLink: 'https://maps.app.goo.gl/jeboq26zkQBb4YG77',
    additionalImages: ['assets/h82.png', 'assets/h83.jpg'],
    galleryImages: [
      'assets/h82.png',
      'assets/h83.jpg',
      'assets/h84.jpeg',
      'assets/h85.jpg',
      'assets/h86.jpg',
      'assets/h81.jpg'
    ],
  ),
  Place(
    number: 'N007',
    title: 'Beira Lake',
    mainImage: 'assets/n71.jpeg',
    details: 'A peaceful lake in the heart of Colombo',
    description:
        'Beira Lake is a serene urban lake in the center of Colombo, offering boat rides and a peaceful escape from the hustle and bustle of the city.',
    type: 'Nature',
    city: 'Colombo, LK',
    locationLink: 'https://maps.app.goo.gl/BPTph4Tdoejar2wL9',
    additionalImages: ['assets/n72.jpeg', 'assets/n73.jpg'],
    galleryImages: [
      'assets/n72.jpeg',
      'assets/n73.jpg',
      'assets/n74.jpg',
      'assets/n75.jpeg',
      'assets/n76.jpeg',
      'assets/n71.jpeg'
    ],
  ),
  Place(
    number: 'N008',
    title: 'Thalangama Wetlands',
    mainImage: 'assets/n81.jpeg',
    details: 'A rich biodiversity hotspot',
    description:
        'Thalangama Wetlands is a protected area on the outskirts of Colombo, known for its rich biodiversity, birdwatching, and peaceful nature trails.',
    type: 'Nature',
    city: 'Colombo, LK',
    locationLink: 'https://maps.app.goo.gl/P8Uenao98C2BSi3c8',
    additionalImages: ['assets/n82.jpg', 'assets/n83.png'],
    galleryImages: [
      'assets/n82.jpg',
      'assets/n83.png',
      'assets/n84.jpeg',
      'assets/n85.jpeg',
      'assets/n86.jpg',
      'assets/n81.jpeg'
    ],
  ),
];
