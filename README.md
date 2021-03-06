# Cluster Manager

A nice script written by Marc Hulsman to submit and monitor jobs in Life Science Grid.

#### PREREQUISITES
1. Add LFC_HOME and LFC_HOST to your environment. e.g. Add to you .bashrc something like:

    ``` bash
    export LFC_HOME='/grid/lsgrid/marc/'
    export LFC_HOST=lfc.grid.sara.nl
    ```
2. Run `startGridSession lsgrid`. This script will:
  * Generate a proxy certificate,
  * Store it in the Myproxy server
  * Delegate it to the WMS with your user name as the delegation ID (DID).

#### INSTALL
1) install 'cluster_manager' using Enhance (see github.com/mhulsman).

#### Uploading Enhance environment to grid
If grid is going to be used, use `<enhance_dir>/upload` file to upload environment to grid (note: this should be done everytime you update enhance environment):

```bash
./upload grid:/<choose_a_name>.dist (e.g. ipengine.dist)
```
	
#### RUN just python

1. Adapt load_env_worker.sh
2. If you need extra files, put them in the work directory (<enhance_dir>/sys_enhance/work) and update environment (last paragraph)
3. If you use ipengine_loadenv.jdl, change XXNJOBXX to the number of jobs you want to run
4. To submit jobs use: 

	```bash
	glite-wms-job-submit -d <delegation_id> -o <jobid_file>  ipengine_loadenv.jdl
	```

#### RUN ipython parallel
1. First, make sure ports are open on <hostname of ui> that were given during install.
2. Then, go to your python directory from which you run your project:
    * cd <your_project>
    * <environment_dir>/cluster.py
    * start controllers and engines from interface
 
3. ipython
   - start tasks
   e.g.:
		```
		from IPython.kernel import client
		
		#METHOD 1
		mec = client.MultiEngineClient()
		mec['b'] = 2  #sets b in all clients
		mec.execute("a = b * 2")
		print mec['a']  #prints for each client: 4
		
		#METHOD 2
		tc = client.TaskClient()
		strtask = """a = b * 2"""
		b = 1 
		task = client.StringTask(strtask, ('a',), {'b':2})
		task_id = tc.run(task)
		tres = tc.get_task_result(task_id,block=True)
		print tres['a']  #prints 2
		```

#### CLUSTER STORAGE
For sending large files to/from engines, make use of submit / receive functions in cluster_storage.py:

* Somewhere on grid, do:

	```python
	id = submit(your_object)
	#or, with fixed id:
	id = submit(your_object,"your_id")
	```

* Somewhere else on grid, do:

	```python
	object = receive(id)    
	
	#clean up
	destroy(id)
	```
