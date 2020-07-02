# AdMob Custom Event Adapter for Pangle

> Please set [Admob](https://developers.google.cn/admob/android/quick-start) in your app first.

* [Setup Pangle Platform](#setup-pangle)
* [Add Pangle to AdMob's mediation](#add-pangle)
* [Initialize Pangle SDK and Adapter](#import-pangle)

<a name="setup-pangle"></a>
## Setup Pangle Platform
### Create a Pangle account

- Please create a [Pangle account](https://ad.oceanengine.com/union/media/login) if you do no have one.


### Create an application and placements in Pangle

- Click `Apps` -> `+ Add App` to create a app for mediation.

<img src="./pics/create-app-home.png" alt="drawing" width="400"/>

<img src="./pics/create-app.png" alt="drawing" width="300"/>

<a name="app-id"></a>
- You will get an app with its `app ID`.

<img src="./pics/app-id.png" alt="drawing" width="400"/>



### Create Ad Placement
- Click `Ad Placements` -> `+ Add Ad Placement` to create the placement for mediation.

<img src="./pics/create-placement.png" alt="drawing" width="400"/>

- Select the ad's type for your app and finish the create.

<img src="./pics/ad-type.png" alt="drawing" width="400"/>

<a name="placementID"></a>
- You will get a placement with its `placement ID`.

<img src="./pics/placement-id.png" alt="drawing" width="400"/>


<a name="add-pangle"></a>
## Add Pangle to AdMob's mediation

### Create mediation

- Click `Mediation` -> `CREATE MEDIATION GROUP` to create a mediation group.


<img src="./pics/add-mediation.png" alt="drawing" width="400"/>


- Select the same ad format which created on Pangle side.

<img src="./pics/ad-format.png" alt="drawing" width="400"/>


- After select the ad unit you created on AdMob which you want to embed mediation, click `ADD CUSTOM EVENT` to set with Pangle.


<img src="./pics/add-custom-event.png" alt="drawing" width="400"/>


- Set info

 - **Class Name**: [packagename].[adaptername], for example,`com.bytedance.pangle.admob.adapter.demo.pangle.adapter.AdmobRewardVideoAdapter`mediation-param

 - **Parameter**: Add {"placementID": "[your placement ID on Pangle](#placementID)"} to Parameter.



<img src="./pics/mediation-param.png" alt="drawing" width="400"/>


- Add adapter's [packagename].[adaptername] to Class Name.

- Add {"slotID": "your slot ID"} to Parameter.

**Please make sure to use JSON to set Parameter. Or you need to customize adapter yourself.**

<a name="import-pangle"></a>
## Initialize Pangle SDK and Adapter

### Initialize Pangle SDK
- Please refer to [SDK Integration](https://partner.oceanengine.com/union/media/union/download/detail?id=20&docId=5de8daa525b16b00113af113&osType=android) to intergrate Pangle SDK in your application.

 * **Please use [app ID](#app-id) to initialize Pangle SDK.**

### Embed Pangle Adapters
- You can find Adapters for different ad format [here](https://github.com/guchan-fout/pangle-admob-custom-adapter/tree/master/AndroidDemo/AdmobAdapterDemo/app/src/main/java/com/bytedance/pangle/admob/adapter/demo/pangle/adapter) , embed them in your app and they can be used with no code change. Also you can customize it for your use case. You can find simple use cases from [Demo](https://github.com/guchan-fout/pangle-admob-custom-adapter/tree/master/AndroidDemo/AdmobAdapterDemo).
