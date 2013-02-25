
Headings =
  edit:
    actions: [
      {title: "Cancel and discard changes",action:"cancel", icon:"ban-circle",dangerous:true}
      {title: "Save and submit changes", action: "save", icon: "ok", safe:true}
    ]
  cabinet:
    actions: [
      {title: "List components in this cabinet", action: "components", icon: "th-list"}
      {title: "Change settings of this cabinet", action: "settings", icon: "edit"}
      {title: "Delete this cabinet", action: "delete", icon: "trash", dangerous:true}
    ]
    badge:
      type: "warning"
      icon: "th"
      text: "Cabinet"
  datasheet:
    actions: [
      {title: "View datasheet in browser", action: "view", icon: "picture"}
      {title: "Download this datasheet", action: "download", icon: "download"}
      {title: "Change properties of this datasheet", action: "edit", icon: "edit"}
      {title: "Delete this datasheet", action: "delete", icon: "trash", dangerous:true}
    ]
    badge:
      type: "info"
      icon: "file"
      text: "Datasheet"
  component:
    actions: [
      {title: "Locate this component", action:"search", icon: "search"}
      {title: "Order history (running low?)", action:"order", icon: "barcode"}
      {title: "Edit details of this component", action:"edit", icon: "edit"}
      {title: "Delete this component", action:"delete", icon: "trash", dangerous:true}
    ]
    badge:
      type: "important"
      icon: "cog"
      text: "Component"