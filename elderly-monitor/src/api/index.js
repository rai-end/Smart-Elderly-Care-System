import request from './request';

const API_PATH = {
  // 用户相关
  USER_INFO: '/user/info',
  USER_LOGIN: '/user/login',
  USER_LOGO_INFO: '/user/logoInfo',
  // 健康数据相关
  ELDER_HEALTH: '/elder/health',
  ELDER_HEART_RATE: '/elder/health/heartRate',
  ELDER_BLOOD_PRESSURE: '/elder/health/bloodPressure',
  ELDER_BLOOD_OXYGEN: '/elder/health/bloodOxygen',
  ELDER_ACTIVITY: '/elder/health/activity',
  ELDER_SLEEP: '/elder/health/sleep',
  ELDER_FALL: '/elder/health/fall',
  ELDER_TEMPERATURE: '/elder/health/temperature',
  //跌倒检测
  FALL_DETECT: '/elder/health/fall/detect',
  FALL_DETECT_STATUS: '/elder/health/fall/status',
  // 管理员相关
  ADMIN_LOGIN: '/admin/login',
  ADMIN_USER_LIST: '/admin/user/list',
  ADMIN_HEALTH_ALL: '/admin/health/all'
};

const DEFAULT_DATA = {
  heartRate: { current: 75, normalRange: '60-100', trend: [70, 72, 75, 73, 76, 74] },
  bloodPressure: { systolic: 125, diastolic: 80, normalRange: '收缩压90-140，舒张压60-90' },
  bloodOxygen: { spO2: 98, normalRange: '95-100', trend: [98, 97, 98, 99, 98, 97] },
  activity: { totalSteps: 2856, periodData: [850, 620, 1100, 286] },
  sleep: { totalSleep: 7.5, deepSleep: 2.5, shallowSleep: 5, quality: '良好' },
  fallDetection: {
    status: '正常',
    lastCheckTime: '',
    riskLevel: '低',
    fallScore: 0
  },
  temperature: { temperature: 36.5, normalRange: '36.0-37.2', status: '正常' },
  logoUser: { userName: '默认用户', deviceStatus: '在线', updateTime: '' },
  userInfo: { userName: '未知用户', deviceId: '' },
  login: { token: '', userInfo: { userName: '', deviceId: '', role: 'user' } },
  adminLogin: { token: '', userInfo: { userName: '', role: 'admin' }, code: 200, msg: '登录成功' },
  adminUserList: []
};

// ====================== 工具函数 ======================
const formatLocalTime = () => new Date().toLocaleString();
const formatLocalTimeOnly = () => new Date().toLocaleTimeString();

/**
 * 统一请求处理函数
 */
const requestHandler = async ({
                                url,
                                method = 'GET',
                                params,
                                data,
                                headers,
                                defaultData = {}
                              }) => {
  try {
    // 强制禁用缓存
    const finalParams = method.toUpperCase() === 'GET'
        ? { ...params, _t: Date.now() }
        : params

    const res = await request({
      url,
      method,
      params: finalParams,
      data,
      headers: {
        'Cache-Control': 'no-cache',
        'Pragma': 'no-cache',
        ...headers
      }
    });

    if (res?.data) {
      return res.data;
    }

    if (res && typeof res === 'object' && !res.code) {
      return res;
    }

    return defaultData;
  } catch (error) {
    console.error(`[接口请求异常] ${url}:`, error.message);
    return defaultData;
  }
};


export const getUserInfo = (deviceId) => {
  return requestHandler({
    url: API_PATH.USER_INFO,
    method: 'GET',
    params: { userId: deviceId },
    defaultData: { ...DEFAULT_DATA.userInfo, deviceId }
  });
};

export const login = (loginForm) => {
  return requestHandler({
    url: API_PATH.USER_LOGIN,
    method: 'POST',
    data: loginForm,
    defaultData: DEFAULT_DATA.login
  }).then(data => {
    return {
      token: data.token || 'mock-token-' + Date.now(),
      userInfo: {
        ...data,
        role: 'user',
        deviceId: data.deviceId || loginForm.deviceId
      }
    };
  });
};

export const getLogoUserData = (deviceId) => {
  return requestHandler({
    url: API_PATH.USER_LOGO_INFO,
    method: 'GET',
    params: { deviceId },
    defaultData: {
      ...DEFAULT_DATA.logoUser,
      updateTime: formatLocalTime(),
      deviceId
    }
  });
};

export const getHealthData = (deviceId) => {
  return requestHandler({
    url: API_PATH.ELDER_HEALTH,
    method: 'GET',
    params: { deviceId },
    defaultData: {
      heartRate: DEFAULT_DATA.heartRate,
      bloodPressure: DEFAULT_DATA.bloodPressure,
      bloodOxygen: DEFAULT_DATA.bloodOxygen,
      activity: DEFAULT_DATA.activity,
      sleep: DEFAULT_DATA.sleep,
      fallDetection: DEFAULT_DATA.fallDetection,
      temperature: DEFAULT_DATA.temperature
    }
  });
};

export const getHeartRateData = (deviceId) => {
  return requestHandler({
    url: API_PATH.ELDER_HEART_RATE,
    method: 'GET',
    params: { deviceId },
    defaultData: DEFAULT_DATA.heartRate
  });
};

export const getBloodPressureData = (deviceId) => {
  return requestHandler({
    url: API_PATH.ELDER_BLOOD_PRESSURE,
    method: 'GET',
    params: { deviceId },
    defaultData: DEFAULT_DATA.bloodPressure
  });
};

export const getBloodOxygenData = (deviceId) => {
  return requestHandler({
    url: API_PATH.ELDER_BLOOD_OXYGEN,
    method: 'GET',
    params: { deviceId },
    defaultData: DEFAULT_DATA.bloodOxygen
  });
};

export const getActivityData = (deviceId) => {
  return requestHandler({
    url: API_PATH.ELDER_ACTIVITY,
    method: 'GET',
    params: { deviceId },
    defaultData: DEFAULT_DATA.activity
  });
};

export const getSleepQualityData = (deviceId) => {
  return requestHandler({
    url: API_PATH.ELDER_SLEEP,
    method: 'GET',
    params: { deviceId },
    defaultData: DEFAULT_DATA.sleep
  });
};

export const getFallDetectionData = (deviceId) => {
  return requestHandler({
    url: API_PATH.ELDER_FALL,
    method: 'GET',
    params: { deviceId },
    defaultData: {
      ...DEFAULT_DATA.fallDetection,
      lastCheckTime: formatLocalTimeOnly(),
      fallScore: 0
    }
  });
};


export const getCameraFallDetection = (deviceId, imgBase64) => {
  return requestHandler({
    url: API_PATH.FALL_DETECT,
    method: 'POST',
    data: {
      deviceId: deviceId,
      imgBase64: imgBase64
    },
    defaultData: {
      ...DEFAULT_DATA.fallDetection,
      lastCheckTime: formatLocalTimeOnly(),
      fallScore: 0
    }
  }).then(data => {
    if (data.isFall !== undefined) {
      const fallScore = data.isFall ? Math.floor(data.confidence * 100) : Math.floor(Math.random() * 30);
      return {
        status: data.isFall ? '跌倒警报' : '正常',
        lastCheckTime: formatLocalTimeOnly(),
        riskLevel: data.isFall ? '高' : '低',
        fallScore: fallScore
      };
    }
    return data;
  });
};

export const getTemperatureData = (deviceId) => {
  return requestHandler({
    url: API_PATH.ELDER_TEMPERATURE,
    method: 'GET',
    params: { deviceId },
    defaultData: DEFAULT_DATA.temperature
  });
};

// ====================== YOLOv11跌倒检测接口 ======================

/**
 * 调用YOLOv11进行跌倒检测
 * @param {string} imgBase64 - base64编码的图片
 * @returns {Promise<Object>} 检测结果
 */
export const detectFallByYOLO = (imgBase64) => {
  return requestHandler({
    url: API_PATH.FALL_DETECT,
    method: 'POST',
    data: { imgBase64 },
    defaultData: {
      fallStatus: 'normal',
      confidence: 0.0,
      msg: '检测失败',
      isFall: false
    }
  });
};

/**
 * 获取YOLOv11跌倒检测服务状态
 * @returns {Promise<Object>} 服务状态
 */
export const getFallDetectionStatus = () => {
  return requestHandler({
    url: API_PATH.FALL_DETECT_STATUS,
    method: 'GET',
    defaultData: {
      available: false,
      msg: '服务状态未知'
    }
  });
};

export const adminLogin = (loginForm) => {
  return requestHandler({
    url: API_PATH.ADMIN_LOGIN,
    method: 'POST',
    data: {
      account: loginForm.username,
      password: loginForm.password
    },
    defaultData: DEFAULT_DATA.adminLogin
  }).then(data => {
    return {
      token: data.token || 'admin-token-' + Date.now(),
      userInfo: {
        ...data.userInfo,
        userName: data.userInfo?.userName || '管理员',
        role: 'admin'
      },
      code: data.code || 200,
      msg: data.msg || '登录成功'
    };
  });
};

export const getAdminUserList = () => {
  return requestHandler({
    url: API_PATH.ADMIN_USER_LIST,
    method: 'GET',
    headers: {
      'Authorization': localStorage.getItem('token') || ''
    },
    defaultData: DEFAULT_DATA.adminUserList
  });
};

export const getAllUsersHealthData = () => {
  return requestHandler({
    url: API_PATH.ADMIN_HEALTH_ALL,
    method: 'GET',
    defaultData: []
  });
};

export const adminLogout = () => {
  return new Promise((resolve) => {
    try {
      localStorage.removeItem('token');
      localStorage.removeItem('userRole');
      resolve(true);
    } catch (error) {
      console.error('[管理员退出登录失败]', error.message);
      resolve(false);
    }
  });
};

export { API_PATH, DEFAULT_DATA };