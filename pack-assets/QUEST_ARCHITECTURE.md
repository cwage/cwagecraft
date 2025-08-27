# CwageCraft Quest System Architecture

## Progression Flow Diagram

```
                           TIER 1: EARLY GAME FOUNDATION
                          ┌─────────────────────────────────┐
                          │  Welcome to CwageCraft!         │
                          │  (Cobblestone Collection)       │
                          └─────────────┬───────────────────┘
                                       │
              ┌────────────────────────┼────────────────────────┐
              │                        │                        │
              ▼                        ▼                        ▼
    ┌─────────────────┐    ┌─────────────────┐      ┌─────────────────┐
    │  Basic Storage  │    │   Fuel Gather   │      │  First Waystone │
    │   (Chests)      │    │    (Coal)       │      │  (Exploration)  │
    └─────────┬───────┘    └─────────┬───────┘      └─────────────────┘
              │                      │
              ▼                      ▼
    ┌─────────────────┐    ┌─────────────────┐
    │  Better Chests  │    │  Basic Power    │
    │  (Iron Chest)   │    │ (Stirling Dyn.) │
    └─────────────────┘    └─────────┬───────┘
                                     │
                                     ▼
                           ┌─────────────────┐
                           │ Thermal Machine │
                           │ (Red. Furnace)  │
                           └─────────┬───────┘
                                     │
                                     ▼
                           ┌─────────────────┐
                           │ Energy Storage  │
                           │ (Basic En.Cube) │
                           └─────────┬───────┘
                                     │
                         ┌───────────▼───────────┐
                         │                       │
                         ▼                       ▼
          ┌──────────────────────────────────────────────────────────┐
          │              TIER 2: AUTOMATION & INFRASTRUCTURE          │
          └──────────────────────────────────────────────────────────┘
                         │                       │
            ┌────────────▼──────────┐           │
            │                       │           │
            ▼                       ▼           ▼
  ┌─────────────────┐    ┌─────────────────┐   ┌─────────────────┐
  │ Create: Andesite│    │Refined Storage  │   │    AE2 Start    │
  │   Age Start     │    │   Controller    │   │   Controller    │
  └─────────┬───────┘    └─────────┬───────┘   └─────────┬───────┘
            │                      │                     │
            ▼                      ▼                     ▼
  ┌─────────────────┐    ┌─────────────────┐   ┌─────────────────┐
  │Create:Mechanical│    │   RS Autocraft  │   │ AE2: Inscriber  │
  │    Machines     │    │    (Crafter)    │   │   Circuits      │
  └─────────┬───────┘    └─────────────────┘   └─────────┬───────┘
            │                                            │
            ▼                                            │
  ┌─────────────────┐                                    │
  │  Create: Brass  │                                    │
  │     Age         │                                    │
  └─────────┬───────┘                                    │
            │                                            │
            ▼                                            │
  ┌─────────────────┐                                    │
  │Create:Mechanical│                                    │
  │   Crafting      │                                    │
  └─────────┬───────┘                                    │
            │                                            │
            └─────────┬──────────────────────────────────┘
                      │
          ┌───────────▼───────────┐
          │                       │
          │  Tinkers: Smeltery    │
          │                       │
          └───────────┬───────────┘
                      │
          ┌───────────▼───────────┐
          │                       │
          ▼                       ▼
┌──────────────────────────────────────────────────────────┐
│              TIER 3: MAGIC & ADVANCED TECH               │
└──────────────────────────────────────────────────────────┘
          │                       │
     ┌────▼─────┐          ┌─────▼─────┐
     │          │          │           │
     ▼          ▼          ▼           ▼
┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────────┐
│Botania: │ │AE2: Mol.│ │EnderIO: │ │Draconic Ev.:│
│ManPool  │ │Assembly │ │Advanced │ │Fusion Craft │
└────┬────┘ └────┬────┘ └────┬────┘ └──────┬──────┘
     │           │           │             │
     ▼           ▼           ▼             ▼
┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────────┐
│Botania: │ │  AE2:   │ │EnderIO: │ │Draconic Ev.:│
│Runic Alt│ │Quantum  │ │Dimens.  │ │Wyvern Tier  │
└────┬────┘ └─────────┘ └─────────┘ └──────┬──────┘
     │                                     │
     ▼                                     │
┌─────────┐                                │
│Botania: │                                │
│Terrasteel                                │
└────┬────┘                                │
     │                                     │
     └─────────────┬───────────────────────┘
                   │
       ┌───────────▼───────────┐
       │                       │
       ▼                       ▼
┌──────────────────────────────────────────────────────────┐
│                 TIER 4: ENDGAME SYSTEMS                  │
└──────────────────────────────────────────────────────────┘
       │                       │
   ┌───▼────┐              ┌───▼────┐
   │        │              │        │
   ▼        ▼              ▼        ▼
┌─────────┐┌─────────┐  ┌─────────┐┌─────────┐
│Draconic:││Mystical:│  │  AE2:   ││RFTools: │
│Draconic ││Supremium│  │Creative ││Creative │
│  Core   ││Essence  │  │Systems  ││ Power   │
└────┬────┘└────┬────┘  └─────────┘└─────────┘
     │          │
     ▼          ▼
┌─────────┐┌─────────┐
│Draconic:││Mystical:│
│Energy   ││Master   │
│ Core    ││Infusion │
└────┬────┘└─────────┘
     │
     ▼
┌─────────┐
│Draconic:│
│ Chaos   │
│Reactor  │
└─────────┘
     │
     ▼
┌─────────────────────┐
│  ULTIMATE MASTER    │
│   (Tech Master)     │
│  Requires ALL Tiers │
└─────────────────────┘
```

## Alternative Progression Paths (Side Quests)

```
EXPLORATION PATH          CULINARY PATH              UTILITY PATH
┌──────────────┐         ┌──────────────┐          ┌──────────────┐
│ Explorer's   │         │ Farmer's     │          │Sophisticated │
│ Compass      │         │ Delight      │          │ Backpacks    │
└──────┬───────┘         └──────┬───────┘          └──────┬───────┘
       │                        │                         │
       ▼                        ▼                         │
┌──────────────┐         ┌──────────────┐                 │
│ Iron Jetpack │         │  Croptopia   │                 │
└──────┬───────┘         │  Expansion   │                 │
       │                 └──────────────┘                 │
       ▼                                                  │
┌──────────────┐         SPACE EFFICIENCY PATH             │
│Diamond Jetpack│         ┌──────────────┐                 │
└──────────────┘         │   Compact    │                 │
                         │  Machines    │                 │
MINING PATH              └──────────────┘                 │
┌──────────────┐                                          │
│ Advanced     │                                          │
│ Mining Dim.  │         ┌─────────────────────────────────┘
└──────────────┘         │
                         ▼
                  ┌──────────────┐
                  │   Ultimate   │
                  │  Integration │
                  └──────────────┘
```

## Quest Dependencies Summary

- **Linear Dependencies**: Core tech progression follows logical mod introduction
- **Flexible Branches**: Multiple paths can be pursued simultaneously  
- **Cross-Path Integration**: Advanced quests require knowledge from multiple paths
- **Optional Content**: Side quests provide bonuses but aren't required for main progression
- **Ultimate Goal**: Final quest requires mastery of all major systems