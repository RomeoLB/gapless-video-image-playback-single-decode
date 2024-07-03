' 20/02/24 Test Standalone version - Debug Generic - RLB

Sub Main()

	m.msgPort = CreateObject("roMessagePort")
	b = CreateObject("roByteArray")
	b.FromHexString("ffffffff")
	color_spec% = (255*256*256*256) + (b[1]*256*256) + (b[2]*256) + b[3]
	videoMode = CreateObject("roVideoMode")
	videoMode.SetBackgroundColor(color_spec%)
	'videomode.Setmode("3840x2160x25p:gfxmemlarge")
	'videomode.Setmode("3840x2160x60p:fullres")
	videomode.Setmode("1920x1080x60p")
	m.sTime = createObject("roSystemTime")
	gpioPort = CreateObject("roControlPort", "BrightSign")
	gpioPort.SetPort(m.msgPort)
	m.SystemLog = CreateObject("roSystemLog")	
	m.PluginInitHTMLWidgetStatic = PluginInitHTMLWidgetStatic
	m.loginURL = "file:///HtmlSite/index.html"

	StartInitHTMLWidgetTimer()

	while true
	    
		msg = wait(0, m.msgPort)
		print "type of msgPort is ";type(msg)
	
		if type(msg) = "roTimerEvent" then	
			timerIdentity = msg.GetSourceIdentity()
			print "Timer msgPort Received " + stri(timerIdentity)
				
			if type (m.InitHTMLWidgetTimer) = "roTimer" then 
				if m.InitHTMLWidgetTimer.GetIdentity() = msg.GetSourceIdentity() then	
					m.PluginInitHTMLWidgetStatic()
				end if
			end if				
		else if type(msg) = "roHtmlWidgetEvent" then
			eventData = msg.GetData()
			if type(eventData) = "roAssociativeArray" and type(eventData.reason) = "roString" then
				Print "roHtmlWidgetEvent = " + eventData.reason
			end if	
		else if type(msg) = "roControlDown" then
			button = msg.GetInt()
			if button = 12 then 
				print " @@@ GPIO 12 pressed @@@  "
				stop
			end if			
		end if				
	end while
End Sub



Function StartInitHTMLWidgetTimer()
	
	print " Set Timer to load HTMLWidget..."
	newTimeout = m.sTime.GetLocalDateTime()
	newTimeout.AddSeconds(2)
	m.InitHTMLWidgetTimer = CreateObject("roTimer")
	m.InitHTMLWidgetTimer.SetPort(m.msgPort)
	m.InitHTMLWidgetTimer.SetDateTime(newTimeout)
	ok = m.InitHTMLWidgetTimer.Start()
End Function



Function PluginInitHTMLWidgetStatic()

	m.PluginRect = CreateObject("roRectangle", 0,0,1920,1080)
	'filepath$ = "Login.js"
	
	is = {
		port: 2999
	}
	m.config = {
		nodejs_enabled: true,
		javascript_injection: { 
		   document_creation: [], 
			document_ready: [],
			deferred: [] 
			'deferred: [{source: filepath$ }]
		},
		javascript_enabled: true,
		port: m.msgPort,
		inspector_server: is,
		brightsign_js_objects_enabled: true,
		url: m.loginURL,
		mouse_enabled: true,
		' storage_quota: "20000000000",
		' storage_path: "sd:/CacheFolder",
		security_params: {websecurity: true}
		'transform: "rot90" 
	}
	
	m.PluginHTMLWidget = CreateObject("roHtmlWidget", m.PluginRect, m.config)
	m.PluginHTMLWidget.Show()
End Function