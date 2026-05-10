-- Packr — MySQL schema + migration data
-- Run once on DreamHost after creating the database

SET NAMES utf8mb4;
SET time_zone = '+00:00';

-- ── TABLES ───────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS users (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL DEFAULT '',
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS trips (
    id         VARCHAR(100) PRIMARY KEY,
    user_id    INT UNSIGNED NOT NULL,
    name       VARCHAR(255) NOT NULL,
    data       LONGTEXT,
    is_shared  TINYINT(1) NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS gear_inventory (
    id         VARCHAR(20) PRIMARY KEY,
    user_id    INT UNSIGNED NOT NULL,
    name       VARCHAR(255) NOT NULL,
    cat        VARCHAR(100) NOT NULL DEFAULT '',
    weight     DECIMAL(8,2) NOT NULL DEFAULT 0,
    qty        INT NOT NULL DEFAULT 1,
    cost       DECIMAL(8,2) NOT NULL DEFAULT 0,
    url        TEXT,
    sort_order INT NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS loadout_templates (
    id         VARCHAR(20) PRIMARY KEY,
    user_id    INT UNSIGNED NOT NULL,
    name       VARCHAR(255) NOT NULL,
    emoji      VARCHAR(10) DEFAULT '🏕️',
    loadout    LONGTEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS addons (
    id          VARCHAR(100) PRIMARY KEY,
    user_id     INT UNSIGNED NOT NULL,
    name        VARCHAR(255) NOT NULL,
    description TEXT,
    items       TEXT,
    sort_order  INT NOT NULL DEFAULT 0,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── USER ─────────────────────────────────────────────────────────────────────
-- Password is blank — run setup.php once to set it

INSERT INTO users (id, email, password_hash) VALUES
(1, 'jesse@jessehaynes.com', '');

-- ── TRIPS ─────────────────────────────────────────────────────────────────────

INSERT INTO trips (id, user_id, name, is_shared, created_at, data) VALUES
('gxo5nd7', 1, 'Memphis', 0, '2026-05-07 00:31:31', '{"mode":"trip","items":[{"qty":null,"sec":"wear","name":"Kuhl khakis","checked":false,"children":null,"expanded":false},{"qty":1,"sec":"wear","name":"Tan Altras","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"wear","name":"Rain jacket","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"wear","name":"Belt","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"toi","name":"Toiletry bag","checked":false,"children":[{"name":"Toothbrush","checked":true},{"name":"Toothpaste","checked":true},{"name":"Deodorant","checked":true},{"name":"Face wash","checked":true},{"name":"Shampoo","checked":true}],"expanded":true},{"qty":null,"sec":"toi","name":"Night guard","checked":false,"children":null,"expanded":false},{"qty":2,"sec":"tops","name":"T-shirts","checked":true,"children":null,"expanded":false},{"qty":1,"sec":"tops","name":"Michigan Hoodie","checked":false,"children":null,"expanded":false},{"qty":1,"sec":"bot","name":"Shorts","checked":false,"children":null,"expanded":false},{"qty":1,"sec":"bot","name":"Gym shorts","checked":true,"children":null,"expanded":false},{"qty":2,"sec":"bot","name":"Underwear","checked":true,"children":null,"expanded":false},{"qty":1,"sec":"bot","name":"Swim trunks","checked":true,"children":null,"expanded":false},{"qty":1,"sec":"socks","name":"Short socks","checked":true,"children":null,"expanded":false},{"qty":1,"sec":"socks","name":"Long socks","checked":true,"children":null,"expanded":false},{"qty":null,"sec":"shoes","name":"Flip flops","checked":true,"children":null,"expanded":false},{"qty":null,"sec":"out","name":"Michigan hat","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"elec","name":"iPad","checked":true,"children":null,"expanded":false},{"qty":null,"sec":"elec","name":"Tech pouch","checked":true,"children":null,"expanded":false},{"qty":null,"sec":"elec","name":"AirPods","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"elec","name":"Apple TV pouch","checked":true,"children":null,"expanded":false},{"qty":null,"sec":"misc","name":"Meds","checked":true,"children":null,"expanded":false},{"qty":null,"sec":"misc","name":"Sling bag","checked":true,"children":null,"expanded":false},{"qty":null,"sec":"misc","name":"Holster (backpack)","checked":true,"children":null,"expanded":false},{"qty":null,"sec":"misc","name":"Travel pillow","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"misc","name":"Water bottle","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"misc","name":"Coffee mug","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"misc","name":"Snack bag","checked":false,"children":[{"name":"Dried fruit","checked":true},{"name":"Rice cakes","checked":true},{"name":"Oatmeal","checked":true},{"name":"Bananas","checked":true},{"name":"Pretzels","checked":true},{"name":"Protein powder","checked":true},{"name":"Protein shaker","checked":true},{"name":"Daily packs","checked":true}],"expanded":true},{"qty":null,"sec":"wear","name":"Columbia Button Down","checked":false,"children":null,"expanded":false}],"notes":"Peabody Hotel\nGraceland at 10:30 on Sat\nRendezvous BBQ","addons":{"bjj":false,"mich":false,"moto":false},"depart":"","nights":1,"archived":true,"savedDate":"May 9, 2026","transport":"car","returnDate":"","destination":"Memphis"}'),

('gf5b2fv', 1, 'Scottish Festival', 0, '2026-05-07 01:46:08', '{"mode":"trip","items":[{"qty":null,"sec":"wear","name":"Kuhl khakis","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"wear","name":"Camo slip-ons","checked":true,"children":null,"expanded":false},{"qty":null,"sec":"wear","name":"Rain jacket","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"wear","name":"Belt","checked":true,"children":null,"expanded":false},{"qty":null,"sec":"toi","name":"Toiletry bag","checked":false,"children":[{"name":"Toothbrush","checked":true},{"name":"Toothpaste","checked":true},{"name":"Deodorant","checked":true},{"name":"Face wash","checked":true},{"name":"Shampoo","checked":true}],"expanded":true},{"qty":2,"sec":"tops","name":"T-shirts","checked":true,"children":null,"expanded":false},{"qty":1,"sec":"tops","name":"Button-downs","checked":true,"children":null,"expanded":false},{"qty":1,"sec":"bot","name":"Shorts","checked":true,"children":null,"expanded":false},{"qty":1,"sec":"bot","name":"Gym shorts","checked":true,"children":null,"expanded":false},{"qty":2,"sec":"bot","name":"Underwear","checked":true,"children":null,"expanded":false},{"qty":1,"sec":"bot","name":"Swim trunks","checked":false,"children":null,"expanded":false},{"qty":1,"sec":"socks","name":"Short socks","checked":false,"children":null,"expanded":false},{"qty":1,"sec":"socks","name":"Long socks","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"shoes","name":"Tan Altras","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"shoes","name":"Flip flops","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"out","name":"Michigan hat","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"elec","name":"Laptop","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"elec","name":"iPad","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"elec","name":"Tech pouch","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"elec","name":"AirPods","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"elec","name":"Apple TV pouch","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"misc","name":"Corp card","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"misc","name":"Meds","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"misc","name":"Sling bag","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"misc","name":"Holster (backpack)","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"misc","name":"Travel pillow","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"misc","name":"Water bottle","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"misc","name":"Coffee mug","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"misc","name":"Snack bag","checked":false,"children":[{"name":"Dried fruit","checked":false},{"name":"Rice cakes","checked":false},{"name":"Oatmeal","checked":false},{"name":"Bananas","checked":false},{"name":"Pretzels","checked":false},{"name":"Protein powder","checked":false},{"name":"Protein shaker","checked":false},{"name":"Daily packs","checked":false}],"expanded":true},{"qty":null,"sec":"moto","name":"Leather jacket","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"moto","name":"Chaps","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"moto","name":"Helmet","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"moto","name":"Gloves","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"moto","name":"Boots","checked":false,"children":null,"expanded":false},{"qty":3,"sec":"moto","name":"GoPro cameras","checked":false,"children":null,"expanded":false},{"qty":null,"sec":"moto","name":"GoPro batteries","checked":false,"children":null,"expanded":false}],"notes":"","addons":{"bjj":false,"mich":false,"moto":true},"depart":"","nights":2,"savedDate":"May 10, 2026","transport":"car","returnDate":"","destination":"Townsend, Tennessee"}'),

('g3t552h', 1, 'Summer', 0, '2026-05-07 12:02:18', '{"mode":"backpacking","loadoutName":"Summer","savedDate":"May 7, 2026","gear":[{"id":"gi2s083","cat":"Pack","qty":1,"name":"ZPacks Arc Blast 55L","weight":20.8},{"id":"g16ps6g","cat":"Pack","qty":1,"name":"ZPacks Nero 38L","weight":10.9},{"id":"gebzpgn","cat":"Pack","qty":1,"name":"ZPacks SubNero 30L","weight":10.5},{"id":"gdlm6t1","cat":"Pack","qty":1,"name":"ZPacks Arc Haul Ultra 70L","weight":21.9},{"id":"gmlg8pv","cat":"Pack","qty":1,"name":"Osprey 75","weight":61.5},{"id":"gwkrzeq","cat":"Sleep System","qty":1,"name":"Hammock (HG w/ Bugnet)","weight":22.22},{"id":"gnm1mds","cat":"Sleep System","qty":1,"name":"Hammock (HG no Bugnet)","weight":14.8},{"id":"ge40p1h","cat":"Sleep System","qty":1,"name":"Suspension (Kammok 10UL)","weight":3.1},{"id":"gi0hlvo","cat":"Sleep System","qty":1,"name":"Pillow (Hammock Gear)","weight":2.9},{"id":"gu9vf2s","cat":"Sleep System","qty":1,"name":"Pillow (Outdoor Vitals)","weight":2.8},{"id":"gwsnabq","cat":"Sleep System","qty":1,"name":"Topquilt (HG Burrow 0°)","weight":26.42},{"id":"ghepppm","cat":"Sleep System","qty":1,"name":"Topquilt (HG Burrow 30°)","weight":17.6},{"id":"g11rn5e","cat":"Sleep System","qty":1,"name":"Topquilt (HG Burrow 40°)","weight":16.15},{"id":"gf23t6o","cat":"Sleep System","qty":1,"name":"Topquilt (Get Out Gear)","weight":17.6},{"id":"go3uzqk","cat":"Sleep System","qty":1,"name":"Underquilt (HG Incubator 0°)","weight":24.64},{"id":"g3xbgwq","cat":"Sleep System","qty":1,"name":"Underquilt (HG Incubator 20°)","weight":20.1},{"id":"gctvxjz","cat":"Sleep System","qty":1,"name":"Underquilt (HG Phoenix 40°)","weight":10.94},{"id":"gim9cc0","cat":"Sleep System","qty":1,"name":"Underquilt Protector","weight":4.62},{"id":"g1vad9j","cat":"Sleep System","qty":1,"name":"Tarp (HG) + Guylines + Stakes","weight":14.5},{"id":"gircjce","cat":"Drink","qty":1,"name":"VersaFlow Filter","weight":1.9},{"id":"g0oayok","cat":"Drink","qty":1,"name":"LifeStraw Flex","weight":0},{"id":"guj5mz8","cat":"Drink","qty":1,"name":"CNOC Water Bag 3L (Clean)","weight":3.2},{"id":"ghk8rht","cat":"Drink","qty":1,"name":"CNOC Water Bag 3L (Dirty)","weight":3.2},{"id":"g2cpf38","cat":"Cook + Fire","qty":1,"name":"Saw (Pocket Gomboy)","weight":6.2},{"id":"g7oemet","cat":"Cook + Fire","qty":1,"name":"Saw (Gomboy 240)","weight":9.3},{"id":"g9bbhep","cat":"Cook + Fire","qty":1,"name":"PJCB + Container","weight":3.7},{"id":"gn96o2a","cat":"Cook + Fire","qty":1,"name":"Lighter (Clipper)","weight":0.4},{"id":"grybtwj","cat":"Cook + Fire","qty":1,"name":"Ferro Rod (Exotac)","weight":0.95},{"id":"gxsln7t","cat":"Cook + Fire","qty":1,"name":"Bellows","weight":0.7},{"id":"gs9tx3b","cat":"Cook + Fire","qty":1,"name":"Stove (BRS)","weight":0.8},{"id":"ggxppae","cat":"Cook + Fire","qty":1,"name":"Fuel (4oz)","weight":7.5},{"id":"g7ijed2","cat":"Cook + Fire","qty":1,"name":"Cook Cup (Toaks) + Bag","weight":4.8},{"id":"gzffkmn","cat":"Cook + Fire","qty":1,"name":"Toaks Titanium Folding Spoon","weight":3.5},{"id":"g2egayk","cat":"Cook + Fire","qty":1,"name":"Coffee Cup (GSI UL)","weight":3.75},{"id":"gmv805e","cat":"Cook + Fire","qty":1,"name":"GSI Coffee Filter","weight":0.35},{"id":"gvnhixp","cat":"Cook + Fire","qty":1,"name":"Cutting Board","weight":1.6},{"id":"g521v12","cat":"Cook + Fire","qty":1,"name":"Skillet (MSR) + Garbage Bag","weight":6.8},{"id":"gubhh8n","cat":"Cook + Fire","qty":1,"name":"Plate (Toaks Titanium)","weight":2.3},{"id":"gatlo9o","cat":"Toiletries","qty":1,"name":"Bag (ZPacks)","weight":0.2},{"id":"gdih99c","cat":"Toiletries","qty":1,"name":"Deodorant","weight":0.8},{"id":"gyf0ryb","cat":"Toiletries","qty":1,"name":"Toothbrush","weight":0.8},{"id":"gva5wjf","cat":"Toiletries","qty":1,"name":"Chapstick","weight":0.3},{"id":"godo2ln","cat":"Toiletries","qty":1,"name":"TP","weight":1},{"id":"gsvu8i4","cat":"Toiletries","qty":1,"name":"Wet Ones Wipes x3","weight":0.6},{"id":"g9n2rme","cat":"Toiletries","qty":1,"name":"Cold Shower Wipes x1","weight":0.4},{"id":"gxekpyu","cat":"Toiletries","qty":1,"name":"Surviveware Wipes x2","weight":1},{"id":"gjz3d1f","cat":"Toiletries","qty":1,"name":"First Aid Kit (Adventure .5)","weight":4.1},{"id":"gz3t1ko","cat":"Toiletries","qty":1,"name":"Sunscreen (Stick)","weight":1.1},{"id":"gvu0b2o","cat":"Toiletries","qty":1,"name":"Bug Spray (Sawyer Picaradin)","weight":5.1},{"id":"gzo03wl","cat":"Misc","qty":1,"name":"Headlamp (NU25)","weight":1.1},{"id":"giz9oz1","cat":"Misc","qty":1,"name":"Battery Pack","weight":4},{"id":"g7mg74h","cat":"Misc","qty":1,"name":"InReach","weight":4},{"id":"g0x0xpm","cat":"Misc","qty":1,"name":"Chair (Helinox Zero + Chair Buddies)","weight":22.1},{"id":"guztiti","cat":"Misc","qty":1,"name":"Ridgeline Phone Holder","weight":1.65},{"id":"g5chwwq","cat":"Misc","qty":1,"name":"Deuce of Spades","weight":0.5},{"id":"gbv4rjr","cat":"Misc","qty":1,"name":"String Lights + Battery","weight":2.05},{"id":"g13in6a","cat":"Misc","qty":1,"name":"Pipe Kit","weight":13.65},{"id":"gpucjmv","cat":"Misc","qty":1,"name":"GoPro + Batts + Charger","weight":19.4},{"id":"gn6hacw","cat":"Misc","qty":1,"name":"Knife (Opinel Filet)","weight":2.6},{"id":"gkv18mk","cat":"Misc","qty":1,"name":"Knife (Mora Garberg)","weight":9.6},{"id":"g2fngcu","cat":"Misc","qty":1,"name":"Snake Bite Kit (Sawyer)","weight":3.8},{"id":"geviwnf","cat":"Misc","qty":1,"name":"Bear Spray","weight":13.1},{"id":"g4d1qlf","cat":"Misc","qty":1,"name":"Paracord 25 + 3 Prusik Knots","weight":2.1},{"id":"g6p2l2w","cat":"Misc","qty":1,"name":"Table (Helinox One)","weight":24.3},{"id":"gagh6mk","cat":"Misc","qty":1,"name":"Yoyito + Bobbers + Tackle","weight":5.2},{"id":"gjsvwqp","cat":"Misc","qty":1,"name":"Multitool (Gerber Dime)","weight":2.6},{"id":"gf6uvie","cat":"Misc","qty":1,"name":"Trekking Poles (REI Traverse)","weight":20},{"id":"gd9wc3v","cat":"Misc","qty":1,"name":"Buff","weight":1.6},{"id":"g5aeyu9","cat":"Misc","qty":1,"name":"Bandana","weight":1.15},{"id":"gj0jcdp","cat":"Misc","qty":1,"name":"M&P Bodyguard .380","weight":15.45},{"id":"gwwa76k","cat":"Clothes","qty":1,"name":"Clothes Bag (Scrubba)","weight":1.8},{"id":"g9lm610","cat":"Clothes","qty":1,"name":"Socks","weight":1.7},{"id":"gygdnb1","cat":"Clothes","qty":1,"name":"Underwear","weight":2.7},{"id":"gjpurdd","cat":"Clothes","qty":2,"name":"Shirt","weight":6.65},{"id":"gn01gzd","cat":"Clothes","qty":1,"name":"TShirt","weight":6.65},{"id":"gb4rs2j","cat":"Clothes","qty":1,"name":"Rain Jacket","weight":7.2},{"id":"gz7wa8x","cat":"Clothes","qty":1,"name":"Rain Kilt","weight":1.85},{"id":"gfdwvex","cat":"Clothes","qty":1,"name":"Camp Shoes (Xeros)","weight":5.4},{"id":"gt2w3p8","cat":"Clothes","qty":1,"name":"Camp Shoes (Slippers)","weight":9.4},{"id":"gnphclq","cat":"Clothes","qty":1,"name":"Camp Shoes (Crocs)","weight":15},{"id":"gvytflc","cat":"Winter","qty":1,"name":"LL Bean Puffy Coat 850","weight":16.9},{"id":"g0fvpaz","cat":"Winter","qty":1,"name":"Mountain Hard Wear Puffy 650","weight":13.2},{"id":"g43ftvb","cat":"Winter","qty":1,"name":"Mittens (Outdoor Research)","weight":8.2},{"id":"gjt3gzr","cat":"Winter","qty":1,"name":"Gloves (Outdoor Research)","weight":2.8},{"id":"gpcsm25","cat":"Winter","qty":1,"name":"Gloves (Hunting)","weight":0},{"id":"g3qnuav","cat":"Winter","qty":1,"name":"Beanie","weight":0},{"id":"gevsvva","cat":"Winter","qty":1,"name":"Down Hood","weight":3.7},{"id":"gm8p17e","cat":"Winter","qty":1,"name":"Down Booties","weight":8.25},{"id":"gl2oclm","cat":"Winter","qty":1,"name":"Down Booties - Covers","weight":5.8},{"id":"gznbelh","cat":"Winter","qty":1,"name":"Camo Slippers","weight":9.65},{"id":"gb8bghi","cat":"Winter","qty":1,"name":"OV Thermal Pants","weight":15},{"id":"g0i1o2v","cat":"Winter","qty":1,"name":"Handwarmers","weight":1.5},{"id":"g8lufgf","cat":"Food","qty":1,"name":"Big Food Bag 3-Day (ZPacks)","weight":0.8},{"id":"gpi449j","cat":"Food","qty":1,"name":"Large Food Bag 5-Day (ZPacks)","weight":1.5},{"id":"g8cdnv5","cat":"Food","qty":1,"name":"Ursak","weight":7.6},{"id":"gohlbj4","cat":"Food","qty":2,"name":"Meals","weight":4},{"id":"gj9spbr","cat":"Food","qty":1,"name":"Snacks (Almonds, AB, Jerky)","weight":6},{"id":"gfv7jch","cat":"Food","qty":3,"name":"Coffee Packets","weight":0.5},{"id":"gvbppv8","cat":"Food","qty":1,"name":"Tea Packet","weight":0},{"id":"gimpylb","cat":"Food","qty":1,"name":"Hot Chocolate","weight":0.02},{"id":"gdjh63j","cat":"Food","qty":2,"name":"Electrolyte Packs","weight":0.02},{"id":"g7btu1f","cat":"Water","qty":1,"name":"Full 700ml Smart Water","weight":36.4},{"id":"gna66f8","cat":"Water","qty":2,"name":"Full 1L Smart Water","weight":36.4}],"loadout":{"g0x0xpm":{"packed":false,"planned":true},"g11rn5e":{"packed":false,"planned":true},"g1vad9j":{"packed":false,"planned":true},"g2egayk":{"packed":false,"planned":true},"g5chwwq":{"packed":false,"planned":true},"g7btu1f":{"packed":false,"planned":true},"g7ijed2":{"packed":false,"planned":true},"g7mg74h":{"packed":false,"planned":true},"g8cdnv5":{"packed":false,"planned":true},"g8lufgf":{"packed":false,"planned":true},"g9bbhep":{"packed":false,"planned":true},"g9n2rme":{"packed":false,"planned":true},"gatlo9o":{"packed":false,"planned":true},"gbv4rjr":{"packed":false,"planned":true},"gctvxjz":{"packed":false,"planned":true},"gdih99c":{"packed":false,"planned":true},"gdjh63j":{"packed":false,"planned":true},"ge40p1h":{"packed":false,"planned":true},"gf6uvie":{"packed":false,"planned":true},"gfdwvex":{"packed":false,"planned":true},"gfv7jch":{"packed":false,"planned":true},"ggxppae":{"packed":false,"planned":true},"gi0hlvo":{"packed":false,"planned":true},"gi2s083":{"packed":false,"planned":true},"gim9cc0":{"packed":false,"planned":true},"giz9oz1":{"packed":false,"planned":true},"gj9spbr":{"packed":false,"planned":true},"gjz3d1f":{"packed":false,"planned":true},"gn96o2a":{"packed":false,"planned":true},"gna66f8":{"packed":false,"planned":true},"godo2ln":{"packed":false,"planned":true},"gohlbj4":{"packed":false,"planned":true},"grybtwj":{"packed":false,"planned":true},"gs9tx3b":{"packed":false,"planned":true},"gsvu8i4":{"packed":false,"planned":true},"gu9vf2s":{"packed":false,"planned":true},"guztiti":{"packed":false,"planned":true},"gva5wjf":{"packed":false,"planned":true},"gvbppv8":{"packed":false,"planned":true},"gvu0b2o":{"packed":false,"planned":true},"gwkrzeq":{"packed":false,"planned":true},"gxekpyu":{"packed":false,"planned":true},"gxsln7t":{"packed":false,"planned":true},"gyf0ryb":{"packed":false,"planned":true},"gz3t1ko":{"packed":false,"planned":true},"gzffkmn":{"packed":false,"planned":true},"gzo03wl":{"packed":false,"planned":true}}}'),

('1_defaults', 1, '__trip_defaults__', 0, '2026-05-07 23:16:42', '{"qty":{"SlingBag":1,"Corp card":1,"Sling bag":1,"Snack Bag":1,"Snack bag":1,"Coffee mug":1,"Tech pouch":1,"Toiletry bag":1,"Water bottle":1,"Travel pillow":1,"Apple TV pouch":1,"Holster (backpack)":1},"extras":{"bot":["Gym shorts","Swim trunks"],"out":["Michigan hat"],"toi":["Night guard"],"elec":["iPad","AirPods","Apple TV pouch"],"misc":["Corp Card","Sling Bag","Holster (Backpack)","Coffee Mug","Snack Bag"],"tops":["Button-downs"],"wear":["Belt","Rain jacket","Hat"],"shoes":["Tan Altras","Flip flops"],"socks":["Short socks","Long socks"]},"hidden":{"Pants":true,"Socks":true,"Sandals":true,"Sneakers":true,"Swim suit":true,"Headphones":true,"Sunglasses":true,"Rain jacket":true,"Light jacket":true,"Reusable bag":true,"Phone charger":true,"Button-down shirts":true,"Outfit for travel day":true},"renames":{"Tech pouch":"Tech Pouch","Toiletry bag":"Toiletry Bag","Water bottle":"Grayl (or Other Water Bottle)","Travel pillow":"Travel Pillow"},"subItems":{"Toiletry bag":[{"name":"Toothbrush"},{"name":"Toothpaste"},{"name":"Deodorant"},{"name":"Face wash"},{"name":"Shampoo"}]},"sectionOrder":{"bot":[{"n":"Shorts","t":"b"},{"n":"Underwear","t":"b"},{"n":"Gym shorts","t":"c"},{"n":"Swim trunks","t":"c"}],"out":[{"n":"Michigan hat","t":"c"}],"toi":[{"n":"Toiletry bag","t":"b"},{"n":"Night guard","t":"c"}],"elec":[{"n":"Laptop","t":"b"},{"n":"Tech pouch","t":"b"},{"n":"iPad","t":"c"},{"n":"AirPods","t":"c"},{"n":"Apple TV pouch","t":"c"}],"misc":[{"n":"Meds","t":"b"},{"n":"Travel pillow","t":"b"},{"n":"Water bottle","t":"b"},{"n":"Corp Card","t":"c"},{"n":"Sling Bag","t":"c"},{"n":"Holster (Backpack)","t":"c"},{"n":"Coffee Mug","t":"c"},{"n":"Snack Bag","t":"c"}],"tops":[{"n":"T-shirts","t":"b"},{"n":"Button-downs","t":"c"}],"wear":[{"n":"Belt","t":"c"},{"n":"Hat","t":"c"}],"shoes":[{"n":"Tan Altras","t":"c"},{"n":"Flip flops","t":"c"}],"socks":[{"n":"Short socks","t":"c"},{"n":"Long socks","t":"c"}]}}');

-- ── GEAR INVENTORY ────────────────────────────────────────────────────────────

INSERT INTO gear_inventory (id, user_id, name, cat, weight, qty, cost, url, sort_order) VALUES
('gi2s083',1,'ZPacks Arc Blast 55L','Pack',20.8,1,350,'',0),
('g16ps6g',1,'ZPacks Nero 38L','Pack',10.9,1,250,'',1),
('gebzpgn',1,'ZPacks SubNero 30L','Pack',10.5,1,0,'',2),
('gdlm6t1',1,'ZPacks Arc Haul Ultra 70L','Pack',21.9,1,0,'',3),
('gmlg8pv',1,'Osprey 75','Pack',61.5,1,200,'',4),
('gwkrzeq',1,'Hammock (HG w/ Bugnet)','Sleep System',22.22,1,129,'',5),
('gnm1mds',1,'Hammock (HG no Bugnet)','Sleep System',14.8,1,59.99,'',6),
('ge40p1h',1,'Suspension (Kammok 10UL)','Sleep System',3.1,1,39,'',7),
('gi0hlvo',1,'Pillow (Hammock Gear)','Sleep System',2.9,1,30,'',8),
('gu9vf2s',1,'Pillow (Outdoor Vitals)','Sleep System',2.8,1,24.97,'',9),
('gwsnabq',1,'Topquilt (HG Burrow 0°)','Sleep System',26.42,1,412.94,'',10),
('ghepppm',1,'Topquilt (HG Burrow 30°)','Sleep System',17.6,1,322.94,'',11),
('g11rn5e',1,'Topquilt (HG Burrow 40°)','Sleep System',16.15,1,300,'',12),
('gf23t6o',1,'Topquilt (Get Out Gear)','Sleep System',17.6,1,64.99,'',13),
('go3uzqk',1,'Underquilt (HG Incubator 0°)','Sleep System',24.64,1,389.95,'',14),
('g3xbgwq',1,'Underquilt (HG Incubator 20°)','Sleep System',20.1,1,329.95,'',15),
('gctvxjz',1,'Underquilt (HG Phoenix 40°)','Sleep System',10.94,1,204.95,'',16),
('gim9cc0',1,'Underquilt Protector','Sleep System',4.62,1,65,'',17),
('g1vad9j',1,'Tarp (HG) + Guylines + Stakes','Sleep System',14.5,1,470.95,'',18),
('gircjce',1,'VersaFlow Filter','Drink',1.9,1,23.6,'',19),
('g0oayok',1,'LifeStraw Flex','Drink',0,1,26.22,'',20),
('guj5mz8',1,'CNOC Water Bag 3L (Clean)','Drink',3.2,1,22.99,'',21),
('ghk8rht',1,'CNOC Water Bag 3L (Dirty)','Drink',3.2,1,22.99,'',22),
('g2cpf38',1,'Saw (Pocket Gomboy)','Cook + Fire',6.2,1,42.95,'',23),
('g7oemet',1,'Saw (Gomboy 240)','Cook + Fire',9.3,1,57.79,'',24),
('g9bbhep',1,'PJCB + Container','Cook + Fire',3.7,1,0,'',25),
('gn96o2a',1,'Lighter (Clipper)','Cook + Fire',0.4,1,0,'',26),
('grybtwj',1,'Ferro Rod (Exotac)','Cook + Fire',0.95,1,0,'',27),
('gxsln7t',1,'Bellows','Cook + Fire',0.7,1,0,'',28),
('gs9tx3b',1,'Stove (BRS)','Cook + Fire',0.8,1,0,'',29),
('ggxppae',1,'Fuel (4oz)','Cook + Fire',7.5,1,0,'',30),
('g7ijed2',1,'Cook Cup (Toaks) + Bag','Cook + Fire',4.8,1,0,'',31),
('gzffkmn',1,'Toaks Titanium Folding Spoon','Cook + Fire',3.5,1,0,'',32),
('g2egayk',1,'Coffee Cup (GSI UL)','Cook + Fire',3.75,1,0,'',33),
('gmv805e',1,'GSI Coffee Filter','Cook + Fire',0.35,1,0,'',34),
('gvnhixp',1,'Cutting Board','Cook + Fire',1.6,1,0,'',35),
('g521v12',1,'Skillet (MSR) + Garbage Bag','Cook + Fire',6.8,1,0,'',36),
('gubhh8n',1,'Plate (Toaks Titanium)','Cook + Fire',2.3,1,0,'',37),
('gatlo9o',1,'Bag (ZPacks)','Toiletries',0.2,1,0,'',38),
('gdih99c',1,'Deodorant','Toiletries',0.8,1,0,'',39),
('gyf0ryb',1,'Toothbrush','Toiletries',0.8,1,0,'',40),
('gva5wjf',1,'Chapstick','Toiletries',0.3,1,0,'',41),
('godo2ln',1,'TP','Toiletries',1,1,0,'',42),
('gsvu8i4',1,'Wet Ones Wipes x3','Toiletries',0.6,1,0,'',43),
('g9n2rme',1,'Cold Shower Wipes x1','Toiletries',0.4,1,0,'',44),
('gxekpyu',1,'Surviveware Wipes x2','Toiletries',1,1,0,'',45),
('gjz3d1f',1,'First Aid Kit (Adventure .5)','Toiletries',4.1,1,0,'',46),
('gz3t1ko',1,'Sunscreen (Stick)','Toiletries',1.1,1,0,'',47),
('gvu0b2o',1,'Bug Spray (Sawyer Picaradin)','Toiletries',5.1,1,0,'',48),
('gzo03wl',1,'Headlamp (NU25)','Misc',1.1,1,0,'',49),
('giz9oz1',1,'Battery Pack','Misc',4,1,0,'',50),
('g7mg74h',1,'InReach','Misc',4,1,0,'',51),
('g0x0xpm',1,'Chair (Helinox Zero + Chair Buddies)','Misc',22.1,1,0,'',52),
('guztiti',1,'Ridgeline Phone Holder','Misc',1.65,1,0,'',53),
('g5chwwq',1,'Deuce of Spades','Misc',0.5,1,0,'',54),
('gbv4rjr',1,'String Lights + Battery','Misc',2.05,1,0,'',55),
('g13in6a',1,'Pipe Kit','Misc',13.65,1,0,'',56),
('gpucjmv',1,'GoPro + Batts + Charger','Misc',19.4,1,0,'',57),
('gn6hacw',1,'Knife (Opinel Filet)','Misc',2.6,1,0,'',58),
('gkv18mk',1,'Knife (Mora Garberg)','Misc',9.6,1,0,'',59),
('g2fngcu',1,'Snake Bite Kit (Sawyer)','Misc',3.8,1,0,'',60),
('geviwnf',1,'Bear Spray','Misc',13.1,1,0,'',61),
('g4d1qlf',1,"Paracord 25' + 3 Prusik Knots",'Misc',2.1,1,0,'',62),
('g6p2l2w',1,'Table (Helinox One)','Misc',24.3,1,0,'',63),
('gagh6mk',1,'Yoyito + Bobbers + Tackle','Misc',5.2,1,0,'',64),
('gjsvwqp',1,'Multitool (Gerber Dime)','Misc',2.6,1,0,'',65),
('gf6uvie',1,'Trekking Poles (REI Traverse)','Misc',20,1,0,'',66),
('gd9wc3v',1,'Buff','Misc',1.6,1,0,'',67),
('g5aeyu9',1,'Bandana','Misc',1.15,1,0,'',68),
('gj0jcdp',1,'M&P Bodyguard .380','Misc',15.45,1,0,'',69),
('gwwa76k',1,'Clothes Bag (Scrubba)','Clothes',1.8,1,0,'',70),
('g9lm610',1,'Socks','Clothes',1.7,1,0,'',71),
('gygdnb1',1,'Underwear','Clothes',2.7,1,0,'',72),
('gjpurdd',1,'Shirt','Clothes',6.65,2,0,'',73),
('gn01gzd',1,'TShirt','Clothes',6.65,1,0,'',74),
('gb4rs2j',1,'Rain Jacket','Clothes',7.2,1,0,'',75),
('gz7wa8x',1,'Rain Kilt','Clothes',1.85,1,0,'',76),
('gfdwvex',1,'Camp Shoes (Xeros)','Clothes',5.4,1,0,'',77),
('gt2w3p8',1,'Camp Shoes (Slippers)','Clothes',9.4,1,0,'',78),
('gnphclq',1,'Camp Shoes (Crocs)','Clothes',15,1,0,'',79),
('gvytflc',1,'LL Bean Puffy Coat 850','Winter',16.9,1,0,'',80),
('g0fvpaz',1,'Mountain Hard Wear Puffy 650','Winter',13.2,1,0,'',81),
('g43ftvb',1,'Mittens (Outdoor Research)','Winter',8.2,1,0,'',82),
('gjt3gzr',1,'Gloves (Outdoor Research)','Winter',2.8,1,0,'',83),
('gpcsm25',1,'Gloves (Hunting)','Winter',0,1,0,'',84),
('g3qnuav',1,'Beanie','Winter',0,1,0,'',85),
('gevsvva',1,'Down Hood','Winter',3.7,1,0,'',86),
('gm8p17e',1,'Down Booties','Winter',8.25,1,0,'',87),
('gl2oclm',1,'Down Booties - Covers','Winter',5.8,1,0,'',88),
('gznbelh',1,'Camo Slippers','Winter',9.65,1,0,'',89),
('gb8bghi',1,'OV Thermal Pants','Winter',15,1,0,'',90),
('g0i1o2v',1,'Handwarmers','Winter',1.5,1,0,'',91),
('g8lufgf',1,'Big Food Bag 3-Day (ZPacks)','Food',0.8,1,35,'',92),
('gpi449j',1,'Large Food Bag 5-Day (ZPacks)','Food',1.5,1,39,'',93),
('g8cdnv5',1,'Ursak','Food',7.6,1,0,'',94),
('gohlbj4',1,'Meals','Food',4,2,0,'',95),
('gj9spbr',1,'Snacks (Almonds, AB, Jerky)','Food',6,1,0,'',96),
('gfv7jch',1,'Coffee Packets','Food',0.5,3,0,'',97),
('gvbppv8',1,'Tea Packet','Food',0,1,0,'',98),
('gimpylb',1,'Hot Chocolate','Food',0.02,1,0,'',99),
('gdjh63j',1,'Electrolyte Packs','Food',0.02,2,0,'',100),
('g7btu1f',1,'Full 700ml Smart Water','Water',36.4,1,0,'',101),
('gna66f8',1,'Full 1L Smart Water','Water',36.4,2,0,'',102);

-- ── LOADOUT TEMPLATES ─────────────────────────────────────────────────────────

INSERT INTO loadout_templates (id, user_id, name, emoji, loadout, created_at) VALUES
('gtk1fe5', 1, 'Summer', '🌲', '{"g0x0xpm":{"packed":false,"planned":true},"g11rn5e":{"packed":false,"planned":true},"g1vad9j":{"packed":false,"planned":true},"g2egayk":{"packed":false,"planned":true},"g5chwwq":{"packed":false,"planned":true},"g7btu1f":{"packed":false,"planned":true},"g7ijed2":{"packed":false,"planned":true},"g7mg74h":{"packed":false,"planned":true},"g8cdnv5":{"packed":false,"planned":true},"g8lufgf":{"packed":false,"planned":true},"g9bbhep":{"packed":false,"planned":true},"g9n2rme":{"packed":false,"planned":true},"gatlo9o":{"packed":false,"planned":true},"gbv4rjr":{"packed":false,"planned":true},"gctvxjz":{"packed":false,"planned":true},"gdih99c":{"packed":false,"planned":true},"gdjh63j":{"packed":false,"planned":true},"ge40p1h":{"packed":false,"planned":true},"gf6uvie":{"packed":false,"planned":true},"gfdwvex":{"packed":false,"planned":true},"gfv7jch":{"packed":false,"planned":true},"ggxppae":{"packed":false,"planned":true},"gi0hlvo":{"packed":false,"planned":true},"gi2s083":{"packed":false,"planned":true},"gim9cc0":{"packed":false,"planned":true},"giz9oz1":{"packed":false,"planned":true},"gj9spbr":{"packed":false,"planned":true},"gjz3d1f":{"packed":false,"planned":true},"gn96o2a":{"packed":false,"planned":true},"gna66f8":{"packed":false,"planned":true},"godo2ln":{"packed":false,"planned":true},"gohlbj4":{"packed":false,"planned":true},"grybtwj":{"packed":false,"planned":true},"gs9tx3b":{"packed":false,"planned":true},"gsvu8i4":{"packed":false,"planned":true},"gu9vf2s":{"packed":false,"planned":true},"guztiti":{"packed":false,"planned":true},"gva5wjf":{"packed":false,"planned":true},"gvbppv8":{"packed":false,"planned":true},"gvu0b2o":{"packed":false,"planned":true},"gwkrzeq":{"packed":false,"planned":true},"gxekpyu":{"packed":false,"planned":true},"gxsln7t":{"packed":false,"planned":true},"gyf0ryb":{"packed":false,"planned":true},"gz3t1ko":{"packed":false,"planned":true},"gzffkmn":{"packed":false,"planned":true},"gzo03wl":{"packed":false,"planned":true}}', '2026-05-07 11:28:03');

-- ── ADDONS ────────────────────────────────────────────────────────────────────

INSERT INTO addons (id, user_id, name, description, items, sort_order, created_at) VALUES
('19cc1c0d-3380-4bca-a6e4-6e2d6b678feb', 1, 'Motorcycle riding', 'Jacket, helmet, chaps, GoPros, boots, gloves', '["Leather jacket","Chaps","Helmet","Gloves","Boots","GoPro cameras","GoPro batteries"]', 0, '2026-05-07 00:00:00'),
('7f19dcc7-4ead-4cfd-b65d-c50f61d83d03', 1, 'BJJ training', 'Gi, NoGi set, gym bag', '["Gi","NoGi set","Gym bag"]', 1, '2026-05-07 00:00:00'),
('795535bc-f884-486f-a3e7-0d4312ec9b05', 1, 'Michigan game', 'Jersey, long sleeve, boggan, Michigan shoes', '["Jersey","Long sleeve T","Michigan boggan","Michigan shoes"]', 2, '2026-05-07 00:00:00');
