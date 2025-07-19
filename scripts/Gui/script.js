function switchTab(tabId) {
  document.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
  document.getElementById(tabId).classList.add('active');
}





async function getItems(item){
  const response = await fetch('../items.json');
  const settings = await response.json();
  return settings[item]

}

async function onSaveClick() {
  const seedItems = await getItems("Seeds");
  const gearItems = await getItems("Gears");
  const EggItems = await getItems("Eggs");

  const GearCraftingItems = ["GearCrafting"];
  GearCraftingItems.push(...await getItems("GearCrafting"));

  const SeedCraftingItems = ["SeedCrafting"];
  SeedCraftingItems.push(...await getItems("SeedCrafting"));

  const EventItems = await getItems("Events");


  const cfg = {
    url: document.getElementById('url').value,
    discordID: document.getElementById('discordID').value,
    VipLink: document.getElementById('VipLink').value,
    TravelingMerchant: +document.getElementById('TravelingMerchant').checked,
    seedItems: {},
    gearItems: {},
    EggItems: {},
    GearCraftingItems: {},
    SeedCraftingItems: {},
    EventItems: {},
  };

  const allLists = {
    seedItems,
    gearItems,
    EggItems,
    GearCraftingItems,
    SeedCraftingItems,
    EventItems,
  };

  for (const [listName, items] of Object.entries(allLists)) {
    items.forEach(item => {
      const key = item.replace(/\s+/g, '');
      const element = document.getElementById(key);
      if (element) {
        cfg[listName][item] = element.checked;
      }
    });
  }

  ahk.Save.Func(JSON.stringify(cfg));
  console.log(cfg);
}
  

  
function applySettings(a) {
    const s = a.data;
    console.log(s);

    document.getElementById('url').value       = s.url;
    document.getElementById('discordID').value = s.discordID;
    document.getElementById('VipLink').value   = s.VipLink;
    document.getElementById('TravelingMerchant').checked  = !!+s.TravelingMerchant

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
    for (const SeedCraft in s.SeedCraftingItems) {
        const formattedSeedCraft = SeedCraft.replace(/\s+/g, '');
        document.getElementById(formattedSeedCraft).checked = !!+s.SeedCraftingItems[SeedCraft];
    }
    for (const Event in s.EventItems) {
        const formattedEvent = Event.replace(/\s+/g, '');
        document.getElementById(formattedEvent).checked = !!+s.EventItems[Event];
    }

}


 document.addEventListener("DOMContentLoaded", () => {
    ahk.ReadSettings.Func()
    window.chrome.webview.addEventListener('message', applySettings);
  })























// Html cool stuff

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
