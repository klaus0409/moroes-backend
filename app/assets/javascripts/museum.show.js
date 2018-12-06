$.ajaxSetup({
	cache: false,
});

var refreshHandler = null;

document.addEventListener("turbolinks:load", function () {
	if ($('#body-museums-show').length <= 0) {
		return;
	}

	var devices = gon.devices;
	for(var i = 0; i < devices.length; i++) {
		if(devices[i].app_id == null){
			devices[i].app_id = "";
		}
	}

	vm = new Vue({
		el: "#museum-control",
		data: {
			checkAll: false,
			devices: devices
		},
		created: function() {
			this.refreshData()
		},
		watch: {
			checkAll: function (val) {
				if (val) {
					for (var i = 0; i < this.devices.length; i++) {
						this.devices[i].check = true
					}
				} else {
					for (var i = 0; i < this.devices.length; i++) {
						this.devices[i].check = false
					}
				}
			}
		},
		methods: {
			doCheckDevice: function (i) {
				var device = this.devices[i];
				device.check = !device.check;
				Vue.set(vm.devices, i, device)
			},

			hasCheckedDevice: function () {
				for (var i = 0; i < this.devices.length; i++) {
					if (this.devices[i].check) {
						return true
					}
				}

				return false
			},
			onStartupApp: function () {
				var params = "";
				for(var i = 0; i < this.devices.length; i++) {
					var device = this.devices[i];
					if (this.devices[i].check) {
						if(device.app_id != null) {
							if(params != "") {
								params += "&"
							}
							params += "devices[" + i + "][device_id]=" + device.id + "&devices[" + i + "][app_id]=" + device.app_id;
						}
					}
				}

				if(params === "") {
					vex.dialog.alert("未指定应用")
					return
				}

				var url = "/start_app.json?" + params;
				$.post(url, function(result) {
					if (result.success) {
						vex.dialog.alert("发送成功")
					} else {
						vex.dialog.alert("发送失败")
					}
				});

			},

			doStartup: function() {
				var device_ids = [];
				for(var i = 0; i < this.devices.length; i++) {
					if (this.devices[i].check) {
						device_ids.push(this.devices[i].id)
					}
				}

				$.post("/start_devices.json", {"devices[]": device_ids}, function(result) {
					if (result.success) {
						vex.dialog.alert("发送成功")
					} else {
						vex.dialog.alert("发送失败")
					}
				})
			},

			doShutdown: function () {
				var device_ids = [];
				for(var i = 0; i < this.devices.length; i++) {
					if (this.devices[i].check) {
						device_ids.push(this.devices[i].id)
					}
				}

				$.post("/stop_devices.json", {"devices[]": device_ids}, function(result) {
					console.log(result);
					if (result.success) {
						vex.dialog.alert("发送成功")
					} else {
						vex.dialog.alert("发送失败")
					}
				})
			},

			broadcastMessage: function() {
				var self = this;
				vex.dialog.open({
					message: '输入广播发送的消息',
					input: [
						'<div class="vex-custom-field-wrapper">',
							'<label for="message">消息</label>',
							'<div class="vex-custom-input-wrapper">',
								'<input name="message" type="text" placeholder="内容" />',
							'</div>',
						'</div>',
						'<div class="vex-custom-field-wrapper">',
							'<label for="duration">循环时长(分钟)</label>',
							'<div class="vex-custom-input-wrapper">',
								'<input name="duration" type="number" value="1" />',
							'</div>',
						'</div>'
					].join(''),
					callback: function (data) {
						if (!data) {
							return
						}

						if (data.message && data.message !== "" && data.duration) {
							var device_ids = [];
							for(var i = 0; i < self.devices.length; i++) {
								if (self.devices[i].check) {
									device_ids.push(self.devices[i].id)
								}
							}

							$.post("/broadcast_message.json", {"devices[]": device_ids, msg: data.message, duration: data.duration}, function(result) {
								console.log(result);
								if (result.success) {
									vex.dialog.alert("发送成功")
								} else {
									vex.dialog.alert("发送失败")
								}
							})
						}
					}
				})
			},

			refreshData: function() {
				var self = this;
				$.get(gon.museum_path, function(result){
					for(var i = 0; i < self.devices.length; i++) {
						var device = self.devices[i];
						var newDevice = null;
						for(var j = 0; j < result.devices.length; j++) {
							if(result.devices[j].id == device.id) {
								newDevice = result.devices[j]
							}
						}

						if(newDevice != null) {
							device.status = newDevice.status;
							device.apps = newDevice.apps;
						}
					}

					refreshHandler = setTimeout(self.refreshData, 5000)
				});
			},

			isRunning: function(device) {
				if ([1, 3].includes(device.status)) {
					return false
				}

				if ([2, 4,5, 6, 7].includes(device.status)) {
					return true
				}

				return false
			}
		}
	})
});


document.addEventListener("turbolinks:load", function () {
	// turbolinks 浏览器没有页面刷新，非当前页则先清除之前的 timeout
	if ($('#body-museums-show').length <= 0) {
		if(refreshHandler) {
			clearTimeout(refreshHandler)
		}
	}
});
