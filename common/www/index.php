 <html>
     <head>
         <meta charset="utf-8" />
         <meta name="viewport" content="width=device-width" />
         <title>Welcome - {{domain}}</title>
     </head>
     <body>
     	<h1>It works!</h1>

     	<h2>To-dos</h2>
     	<ul>
     		<li>1. Copy/install/setup your application code in the <code>www</code> folder</li>
     		<li>2. In your application connect to the database with the following credentials</li>
     		<ul>
     			<li>Database name: <code>{{domain}}</code></li>
     			<li>Database user: <code>{{domain}}</code></li>
     			<li>Database password: <code>{{domain}}</code></li>
     		</ul>
     		<li>3. Any email sent by your PHP code will be intercepted by the Mailcatcher container at <a href="http://mailcatcher.localhost">http://mailcatcher.localhost</a></li>
     		<li>4. Configure your IDE to listen for <a href="https://xdebug.org/">XDebug</a> connections on port <code>9001</code></li>
     	</ul>
     </body>
 </html>