  function switchTab(tabId) {
    document.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');
  }

  

	function ahkSave(ele) {
		ahk.Save.Func(ele);
	}





  function onSaveClick() {


    const seedItems = [
            "Carrot Seed", "Strawberry Seed", "Blueberry Seed", "Orange Tulip", "Tomato Seed", "Corn Seed"
             , "Daffodll Seed", "Watermelon Seed", "Pumpkin Seed"
             , "Apple Seed", "Bamboo Seed", "Coconut Seed", "Cactus Seed"
             , "Dragon Fruit Seed", "Mango Seed", "Grape Seed", "Mushroom Seed"
             , "Pepper Seed", "Cacao Seed", "Beanstalk Seed", "Ember Lily", "Sugar Apple", "Burning Bud",


    ]

    const gearItems = [
        "Watering Can", "Trowel", "Recall Wrench", 
        "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Magnifying Glass",
        "Tanning Mirror", "Master Sprinkler", "Cleaning Spray",
        "Favorite Tool", "Harvest Tool", "Friendship Pot",
    ]

    const EggItems = [
        "Common Egg", "Common Summer Egg",  
        "Rare Summer Egg", "Mythical Egg","Paradise Egg",       
        "Bee Egg", "Bug Egg",            
    ]



    const GearCraftingItems = [
        "GearCrafting", // This to enable/disable setting.
        "Lighting Rod", "Reclaimer",
        "Tropical Mist Sprinkler",
        "Berry Blusher Sprinkler",
        "Spice Spirtzer Sprinkler",
        "Sweet Soaker Sprinkler",
        "Flower Froster Sprinkler",
        "Stalk Sprout Sprinkler",
        "Mutation Spray Choc",
        "Mutation Spray Chilled",
        "Mutation Spray Shocked",
        "Anti Bee Egg",
        "Pack Bee",
    ]


  const cfg = {
    url:       document.getElementById('url').value,
    discordID: document.getElementById('discordID').value,
    VipLink:   document.getElementById('VipLink').value,
    DinoEvent:   +document.getElementById('DinoEvent').checked,
    seedItems : {},
    gearItems: {},
    EggItems: {},
    GearCraftingItems: {},
  };

  const allLists = { seedItems, gearItems, EggItems, GearCraftingItems, };

  for (const [listName, items] of Object.entries(allLists)) {
    items.forEach(item => {
    const key = item.replace(/\s+/g, ''); // ← fix here
    const element = document.getElementById(key);
    if (element) {
      cfg[listName][item] = element.checked;
    }
    });
  }


    ahkSave(JSON.stringify(cfg))
	  console.log(cfg)
}
  

  
function applySettings(a) {
    const s = a.data;
    console.log(s);

    document.getElementById('url').value       = s.url;
    document.getElementById('discordID').value = s.discordID;
    document.getElementById('VipLink').value   = s.VipLink;
    document.getElementById('DinoEvent').checked  = !!+s.DinoEvent

    for (const seed in s.SeedItems) {
        const formattedSeed = seed.replace(/\s+/g, '');
        document.getElementById(formattedSeed).checked = !!+s.SeedItems[seed];
    }
    for (const gear in s.GearItems) {
        const formattedGear = gear.replace(/\s+/g, '');
        document.getElementById(formattedGear).checked = !!+s.GearItems[gear];
    }
    for (const egg in s.EggItems) {
        const formattedEgg = egg.replace(/\s+/g, '');
        document.getElementById(formattedEgg).checked = !!+s.EggItems[egg];
    }
    for (const GearCraft in s.GearCraftingItems) {
        const formattedGearCraft = GearCraft.replace(/\s+/g, '');
        document.getElementById(formattedGearCraft).checked = !!+s.GearCraftingItems[GearCraft];
    }

}







document.querySelectorAll('.tabs button').forEach(button => {
  button.addEventListener('click', function() {
    document.querySelectorAll('.tabs button').forEach(btn => {
      btn.classList.remove('tab-button-active');
    });
    this.classList.add('tab-button-active');
  });
});

document.addEventListener('DOMContentLoaded', function() {
  document.querySelector('.tabs button').classList.add('tab-button-active');
});












 document.addEventListener("DOMContentLoaded", () => {
    window.chrome.webview.addEventListener('message', applySettings);
  })

document.querySelectorAll('.custom-dropdown').forEach(dropdown => {
  const selected = dropdown.querySelector('.custom-dropdown-selected');
  const options = dropdown.querySelector('.custom-dropdown-options');
  const hiddenInput = document.getElementById('hiddenSelector');

  selected.addEventListener('click', () => {
    options.style.display = options.style.display === 'block' ? 'none' : 'block';
  });

  options.querySelectorAll('[data-value]').forEach(option => {
    option.addEventListener('click', () => {
      const value = option.getAttribute('data-value');
      selected.textContent = option.textContent;
      hiddenInput.value = value;
      options.style.display = 'none';
    });
  });

  document.addEventListener('click', e => {
    if (!dropdown.contains(e.target)) {
      options.style.display = 'none';
    }
  });
});


document.querySelectorAll('.custom-dropdown-options div[data-value]').forEach(option => {
  option.addEventListener('click', function () {
    const selected = this.closest('.custom-dropdown').querySelector('.custom-dropdown-selected');
    const selectedKey = selected.getAttribute('data-value');

    const hiddenInput = document.querySelector(`input[type="hidden"][data-value="${selectedKey}"]`);

    const value = this.getAttribute('data-value');
    const text = this.textContent.trim();

    if (hiddenInput) {
      hiddenInput.value = value;
    }

    const img = this.querySelector('img');
    if (img) {
      const newImg = img.cloneNode(true);
      selected.innerHTML = ''; 
      selected.appendChild(newImg);
      selected.append(' ' + text);
    } else {
      selected.textContent = text;
    }
  });
});






function selectDropdownValueByData(value) {
  const option = document.querySelector(`.custom-dropdown-options div[data-value="${value}"]`);
  if (!option) return;

  const dropdown = option.closest('.custom-dropdown');
  const selected = dropdown.querySelector('.custom-dropdown-selected');
  const hiddenInput = document.getElementById('hiddenSelector');
  const text = option.textContent.trim();

  hiddenInput.value = value;

  const img = option.querySelector('img');
  if (img) {
    const newImg = img.cloneNode(true);
    selected.innerHTML = '';
    selected.appendChild(newImg);
    selected.append(' ' + text);
  } else {
    selected.textContent = text;
  }

  dropdown.querySelector('.custom-dropdown-options').style.display = 'none';
}
